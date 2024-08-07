import 'package:flutter/material.dart';

class VpnFormScreen extends StatelessWidget {
  final String clientId;

  VpnFormScreen({required this.clientId});

  @override
  Widget build(BuildContext context) {
    // Your form implementation here
    return Scaffold(
      appBar: AppBar(
        title: Text('Create VPN for Client $clientId'),
      ),
      body: Center(
        child: Text('VPN Form Screen for Client $clientId'),
      ),
    );
  }
}
