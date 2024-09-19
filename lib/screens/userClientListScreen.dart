import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpn_management/providers/client_provider.dart';
import 'package:vpn_management/screens/clientForm.dart';
import 'package:vpn_management/screens/userVpnListScreen.dart';

class Userclientlistscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Add the background image
          Positioned.fill(
            child: Image.asset(
              'assets/VPN.jpg', // Background image
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              // Transparent AppBar
              Container(
                color: Colors.transparent,
                child: AppBar(
                  title: Text('Clients'),
                  backgroundColor: Colors.transparent,
                  elevation: 0, // Remove shadow to keep it sleek
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
                                tileColor: Colors.transparent, // Transparent row background
                                title: Text(client.clientName ?? 'No Name'),
                                subtitle: Text(client.email ?? 'No Email'),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => UserVpnListScreen(clientId: client.id!),
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
