import 'package:flutter/material.dart';
import 'package:vpn_management/models/vpn.dart';
import 'package:vpn_management/services/vpnservice.dart';
import 'package:vpn_management/models/client.dart'; // Import Client model
import 'package:http/http.dart' as http;
import 'dart:convert';

class VpnFormScreen extends StatefulWidget {
  final String? vpnId;
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
  List<Client> _allClients = []; // List to store all clients

  @override
  void initState() {
    super.initState();
    _vpnService = VpnService(
      baseUrl: 'http://localhost:3001',
      token: 'your-auth-token',
    );

    if (widget.vpnId != null) {
      _loadVpnDetails(widget.vpnId!);
    } else {
      _userId = widget.clientId;
    }

    _fetchClients(); // Load clients
  }

  Future<void> _fetchClients() async {
    try {
      final clients = await fetchClients();
      setState(() {
        _allClients = clients;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading clients: $error')),
      );
    }
  }

  Future<List<Client>> fetchClients() async {
    final url = Uri.parse('http://localhost:3001/clients');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((clientJson) => Client.fromJson(clientJson)).toList();
    } else {
      throw Exception('Failed to load clients');
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
      userId: _userId!,
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

  void _showClientSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Clients'),
          content: SingleChildScrollView(
            child: Column(
              children: _allClients.map((client) {
                return CheckboxListTile(
                  title: Text(client.clientName ?? 'Unknown'),
                  value: _clients.contains(client.id),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _clients.add(client.id!);
                      } else {
                        _clients.remove(client.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                  onPressed: _showClientSelectionDialog,
                  child: Text('Select Clients'),
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