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
        ],
      ),
      body: FutureBuilder(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => VpnFormScreen(clientId: clientId),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
