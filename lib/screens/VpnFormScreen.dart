import 'package:flutter/material.dart';
import 'package:vpn_management/models/vpn.dart';
import 'package:vpn_management/services/vpnservice.dart'; // Import your service

class VpnFormScreen extends StatefulWidget {
  final String? vpnId; // Optional ID for editing an existing VPN
  final String clientId;

  VpnFormScreen({this.vpnId, required this.clientId});

  @override
  _VpnFormScreenState createState() => _VpnFormScreenState();
}

class _VpnFormScreenState extends State<VpnFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late VpnService _vpnService;

  String _description = '';
  String _url = '';
  String _port = '';
  String _pwd = '';
  String _address = '';
  List<String> _clients = [];
  String? _userId;

  @override
  void initState() {
    super.initState();
    _vpnService = VpnService(
      baseUrl: 'http://localhost:3001', // Replace with your API base URL
      token: 'your-auth-token', // Replace with your authentication token
    );

    if (widget.vpnId != null) {
      _loadVpnDetails(widget.vpnId!);
    } else {
      // Set the _userId when creating a new VPN
      _userId = widget.clientId;
    }
  }

  Future<void> _loadVpnDetails(String id) async {
    try {
      final vpn = await _vpnService.getVpn(id);
      setState(() {
        _description = vpn.description;
        _url = vpn.url;
        _port = vpn.port;
        _pwd = vpn.pwd;
        _address = vpn.address;
        _clients = vpn.clients;
        _userId = vpn.userId;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading VPN details: $error')),
      );
    }
  }

  Future<void> _saveVpn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    if (_userId == null || _userId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Client ID is missing.')),
      );
      return;
    }

    final vpn = Vpn(
      id: widget.vpnId ?? '',
      description: _description,
      url: _url,
      port: _port,
      pwd: _pwd,
      address: _address,
      userId: _userId!, // Now it's safe to use the bang operator
      clients: _clients,
    );

    try {
      if (widget.vpnId == null) {
        await _vpnService.createVpn(vpn);
      } else {
        await _vpnService.updateVpn(widget.vpnId!, vpn);
      }
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving VPN: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vpnId == null ? 'Add VPN' : 'Edit VPN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value!,
                ),
                TextFormField(
                  initialValue: _url,
                  decoration: InputDecoration(labelText: 'URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a URL';
                    }
                    return null;
                  },
                  onSaved: (value) => _url = value!,
                ),
                TextFormField(
                  initialValue: _port,
                  decoration: InputDecoration(labelText: 'Port'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a port';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) => _port = value!,
                ),
                TextFormField(
                  initialValue: _pwd,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  onSaved: (value) => _pwd = value!,
                ),
                TextFormField(
                  initialValue: _address,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                  onSaved: (value) => _address = value!,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveVpn,
                  child: Text(widget.vpnId == null ? 'Add VPN' : 'Update VPN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
