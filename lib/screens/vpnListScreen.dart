import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpn_management/providers/VpnProvider.dart';
import 'package:vpn_management/screens/VpnFormScreen.dart';

class VpnListScreen extends StatelessWidget {
  final String clientId;

  VpnListScreen({required this.clientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VPNs for Client $clientId'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => VpnFormScreen(clientId: clientId),
                ),
              );
            },
          ),
          TextButton(
            onPressed: () {
              // Handle custom button press action here
              print('Custom Button Pressed');
            },
            child: Text(
              'Custom Button',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.green, // Button background color
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => VpnFormScreen(clientId: clientId),
                  ),
                );
              },
              child: Text('Create VPN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Button background color
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<VpnProvider>(context, listen: false)
                  .fetchVpnsForClient(clientId),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error: ${snapshot.error}'); // Log the error
                  return Center(child: Text('Error loading VPNs'));
                } else {
                  return Consumer<VpnProvider>(
                    builder: (ctx, vpnProvider, _) => ListView.builder(
                      itemCount: vpnProvider.vpns.length,
                      itemBuilder: (ctx, index) {
                        final vpn = vpnProvider.vpns[index];
                        return ListTile(
                          title: Text(vpn.description ?? 'No Description'),
                          subtitle: Text(vpn.url ?? 'No URL'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => VpnFormScreen(clientId: clientId),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue, // Customize the background color
        tooltip: 'Add VPN', // Add a tooltip
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Customize the shape
        ),
      ),
    );
  }
}
