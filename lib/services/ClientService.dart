import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client.dart';

class ClientService {
  final String baseUrl = 'http://localhost:3001'; // Ensure this URL is correct

  Future<List<Client>> fetchClients() async {
    final response = await http.get(Uri.parse('$baseUrl/clients'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print('Clients data: $data'); // Log the response data
      return data.map((clientJson) => Client.fromJson(clientJson)).toList();
    } else {
      print('Failed to load clients: ${response.body}'); // Log the error response
      throw Exception('Failed to load clients');
    }
  }

 Future<Client> addClient(Client client) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/clients'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(client.toJson()),
      );

      if (response.statusCode == 201) {
        return Client.fromJson(json.decode(response.body));
      } else {

        print('Failed to add client: ${response.body}'); // Log the error response
        throw Exception('Failed to add client');
      }
    } catch (error) {
      print('Error adding client: $error'); // Log the error
      throw error;
    }
  }


 Future<Client> updateClient(Client client) async {
  final response = await http.patch(
    Uri.parse('$baseUrl/clients/${client.id}'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(client.toJson()),
  );

  if (response.statusCode == 200) {
    return Client.fromJson(json.decode(response.body));
  } else {
    print('Failed to update client: ${response.body}'); // Log the error response
    throw Exception('Failed to update client');
  }
}

  Future<void> deleteClient(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/clients/$id'));

    if (response.statusCode != 200) {
      print('Failed to delete client: ${response.body}'); // Log the error response
      throw Exception('Failed to delete client');
    }
  }
}
