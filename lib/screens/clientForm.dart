import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/client_provider.dart';
import '../models/client.dart';
import '../services/api_service.dart'; // Import the AuthService if needed

class ClientForm extends StatefulWidget {
  final Client? client;

  ClientForm({this.client});

  @override
  _ClientFormState createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      _clientNameController.text = widget.client!.clientName ?? '';
      _emailController.text = widget.client!.email ?? '';
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final client = Client(
        id: widget.client?.id,
        clientName: _clientNameController.text,
        email: _emailController.text,
      );

      final clientProvider = Provider.of<ClientProvider>(context, listen: false);
      if (widget.client == null) {
        // Create new client
        await clientProvider.addClient(client);
      } else {
        // Update existing client
        await clientProvider.updateClient(client);
      }

      Navigator.of(context).pop();
    }
  }

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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.client == null ? 'Add Client' : 'Update Client',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _clientNameController,
                          decoration: InputDecoration(labelText: 'Client Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a client name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _saveForm,
                          child: Text(widget.client == null ? 'Add Client' : 'Update Client'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}