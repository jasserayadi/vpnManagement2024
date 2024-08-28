import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:vpn_management/models/vpn.dart'; // Import your model

class VpnService {
  final String baseUrl;
  final String token;

  VpnService({required this.baseUrl, required this.token});

  Future<Vpn> createVpn(Vpn vpn) async {
    try {
      final url = Uri.parse('$baseUrl/vpn');
      print('Sending POST request to $url');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Ensure the token is included
        },
        body: json.encode(vpn.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        return Vpn.fromJson(json.decode(response.body));
      } else {
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Unknown error';
        throw Exception('Failed to add VPN: $errorMessage');
      }
    } catch (error) {
      print('Error adding VPN: $error');
      rethrow;
    }
  }

  Future<Vpn> updateVpn(String id, Vpn vpn) async {
    try {
      final url = Uri.parse('$baseUrl/vpn/$id');
      print('Sending PATCH request to $url');

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Ensure the token is included
        },
        body: json.encode(vpn.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return Vpn.fromJson(json.decode(response.body));
      } else {
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Unknown error';
        throw Exception('Failed to update VPN: $errorMessage');
      }
    } catch (error) {
      print('Error updating VPN: $error');
      rethrow;
    }
  }

  Future<Vpn> getVpn(String id) async {
    try {
      final url = Uri.parse('$baseUrl/vpn/$id');
      print('Sending GET request to $url');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Ensure the token is included
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return Vpn.fromJson(json.decode(response.body));
      } else {
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Unknown error';
        throw Exception('Failed to get VPN: $errorMessage');
      }
    } catch (error) {
      print('Error getting VPN: $error');
      rethrow;
    }
  }
 Future<Map<String, dynamic>> getVpnConnectionDetails(String id) async {
    final url = Uri.parse('$baseUrl/vpn/$id/connection-details');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorMessage = json.decode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Failed to get VPN details: $errorMessage');
    }
  }
}



