import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vpn_management/models/vpn.dart';
import 'package:vpn_management/providers/VpnProvider.dart';
import 'package:vpn_management/screens/VpnFormScreen.dart';

class VpnListScreen extends StatefulWidget {
  final String clientId;

  VpnListScreen({required this.clientId});

  @override
  _VpnListScreenState createState() => _VpnListScreenState();
}

class _VpnListScreenState extends State<VpnListScreen> {
  Map<String, bool> vpnConnectionStatus = {}; // Track connection status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VPNs for Client ${widget.clientId}'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => VpnFormScreen(clientId: widget.clientId),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: Provider.of<VpnProvider>(context, listen: false)
                  .fetchVpnsForClient(widget.clientId),
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
                        final isConnected = vpnConnectionStatus[vpn.id] ?? false;

                        return ListTile(
                          title: Text(vpn.description ?? 'No Description'),
                          subtitle: Text(vpn.url ?? 'No URL'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!isConnected)
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      vpnConnectionStatus[vpn.id] = true;
                                    });
                                    connectToVpn(vpn);
                                  },
                                  child: Text('Connect'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                              if (isConnected)
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      vpnConnectionStatus[vpn.id] = false;
                                    });
                                    disconnectFromVpn(vpn);
                                  },
                                  child: Text('Disconnect'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.blue,
                                onPressed: () {
                                  // Navigate to the VPN form screen for editing
                                
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  // Implement delete functionality
                                  _confirmDelete(vpn.id);
                                },
                              ),
                            ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => VpnFormScreen(clientId: widget.clientId),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        tooltip: 'Add VPN',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(String vpnId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this VPN?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await deleteVpn(vpnId);
    }
  }

  Future<void> deleteVpn(String vpnId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3001/vpn/$vpnId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        // Successfully deleted
        setState(() {
          // Remove the VPN from the list
          Provider.of<VpnProvider>(context, listen: false).vpns.removeWhere((vpn) => vpn.id == vpnId);
        });
      } else {
        print('Failed to delete VPN: ${response.body}');
      }
    } catch (e) {
      print('Error deleting VPN: $e');
    }
  }

  Future<void> connectToVpn(Vpn vpn) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3001/vpn/connect'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(vpn.toJson()),
      );

      if (response.statusCode == 201) {
        print('Connected to VPN successfully');
        print('Command output: ${response.body}');
        setState(() {
          vpnConnectionStatus[vpn.id] = true;
        });
      } else {
        print('Failed to connect to VPN: ${response.body}');
      }
    } catch (e) {
      print('An error occurred while connecting to VPN: $e');
    }
  }

  Future<void> disconnectFromVpn(Vpn vpn) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3001/vpn/disconnect'),
      );

      if (response.statusCode == 200) {
        print('Disconnected from VPN successfully');
        setState(() {
          vpnConnectionStatus[vpn.id] = false;
        });
      } else {
        print('Failed to disconnect from VPN: ${response.body}');
      }
    } catch (e) {
      print('An error occurred while disconnecting from VPN: $e');
    }
  }
}