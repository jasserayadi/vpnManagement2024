import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/client_provider.dart';
import './clientForm.dart';
import './vpnlistscreen.dart'; // Import the new VPN list screen
import '../services/api_service.dart'; // Import the AuthService for logout

class ClientListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/VPN.jpg', // Background image
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Container(
                color: Colors.transparent, // Make the AppBar background transparent
                child: AppBar(
                  title: Text('Clients'),
                  backgroundColor: Colors.transparent, // Semi-transparent background
                  actions: [
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/create-client');
                      },
                    ),
                    IconButton( // Add the logout button here
                      icon: Icon(Icons.logout),
                      onPressed: () async {
                        try {
                          await AuthService().logout(); // Call logout method
                          Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error during logout')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: Provider.of<ClientProvider>(context, listen: false).fetchClients(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error loading clients'));
                    } else {
                      return Consumer<ClientProvider>(
                        builder: (ctx, clientProvider, _) => ListView.builder(
                          itemCount: clientProvider.clients.length,
                          itemBuilder: (ctx, index) {
                            final client = clientProvider.clients[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: ListTile(
                                tileColor: Colors.transparent, // Make all rows transparent
                                title: Text(client.clientName ?? 'No Name'),
                                subtitle: Text(client.email ?? 'No Email'),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => VpnListScreen(clientId: client.id!),
                                    ),
                                  );
                                },
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        if (client.id != null) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) => ClientForm(client: client),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Cannot update client with null ID')),
                                          );
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        if (client.id != null) {
                                          clientProvider.deleteClient(client.id!);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Cannot delete client with null ID')),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
