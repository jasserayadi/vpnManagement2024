import 'package:flutter/material.dart';
import '../models/client.dart';
import 'package:vpn_management/services/ClientService.dart';

class ClientProvider with ChangeNotifier {
  final ClientService _clientService = ClientService();
  List<Client> _clients = [];

  List<Client> get clients => [..._clients];

Future<void> fetchClients() async {
  try {
    _clients = await _clientService.fetchClients();
    notifyListeners();
  } catch (error) {
    print('Error fetching clients: $error'); // Log the error
    throw error;
  }
}



  Future<void> addClient(Client client) async {
    try {
      final newClient = await _clientService.addClient(client);
      _clients.add(newClient);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateClient(Client client) async {
    try {
      final updatedClient = await _clientService.updateClient(client);
      final index = _clients.indexWhere((c) => c.id == client.id);
      if (index >= 0) {
        _clients[index] = updatedClient;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteClient(String id) async {
    try {
      await _clientService.deleteClient(id);
      _clients.removeWhere((client) => client.id == id);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
