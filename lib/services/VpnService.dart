import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vpn_management/models/vpn.dart'; // Import your model

class VpnService {
  final String baseUrl;
  final String token;

  VpnService({required this.baseUrl, required this.token});

  Future<List<Vpn>> findAllByClient(String clientId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/vpn?clientId=$clientId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Vpn.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load VPNs');
    }
  }

  Future<Vpn> getVpn(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/vpn/$id'));

    if (response.statusCode == 200) {
      return Vpn.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load VPN');
    }
  }

  Future<Vpn> createVpn(Vpn vpn) async {
    final response = await http.post(
      Uri.parse('$baseUrl/vpn'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(vpn.toJson()),
    );

    if (response.statusCode == 201) {
      return Vpn.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create VPN');
    }
  }

  Future<Vpn> updateVpn(String id, Vpn vpn) async {
    final response = await http.put(
      Uri.parse('$baseUrl/vpn/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(vpn.toJson()),
    );

    if (response.statusCode == 200) {
      return Vpn.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update VPN');
    }
  }

  Future<void> deleteVpn(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/vpn/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete VPN');
    }
  }
}
