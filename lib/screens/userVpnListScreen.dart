import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpn_management/models/vpn.dart';
import 'package:vpn_management/providers/VpnProvider.dart';
import 'package:http/http.dart' as http;

class userVpnListScreen extends StatelessWidget {
  final String clientId;

  userVpnListScreen({required this.clientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VPNs for Client $clientId'),
        actions: [
          TextButton(
            onPressed: () {
              print('Custom Button Pressed');
            },
            child: Text(
              'Custom Button',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green, // Button background color
            ),
          ),
        ],
      ),
      body: Expanded(
        child: FutureBuilder(
          future: Provider.of<VpnProvider>(context, listen: false)
              .fetchVpnsForClient(clientId),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
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
                      onTap: () {
                        connectToVpn(vpn); // Use the VPN ID instead of the config path
                      },
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> connectToVpn(Vpn vpn) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3001/vpn/connect'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(vpn.toJson()), // Send the VPN object as JSON
      );

      if (response.statusCode == 201) {
        print('Connected to VPN successfully');
        print('Command output: ${response.body}');
      } else {
        print('Failed to connect to VPN: ${response.body}');
      }
    } catch (e) {
      print('An error occurred while connecting to VPN: $e');
    }
  }
}
