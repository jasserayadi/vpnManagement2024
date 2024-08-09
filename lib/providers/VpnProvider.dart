import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/vpn.dart';

class VpnProvider with ChangeNotifier {
  List<Vpn> _vpns = [];

  List<Vpn> get vpns => _vpns;

  final String baseUrl = 'http://localhost:3001'; // Ensure this URL is correct

  Future<void> fetchVpnsForClient(String clientId) async {
    final url = '$baseUrl/vpn?clientId=$clientId';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer YOUR_JWT_TOKEN', // Replace YOUR_JWT_TOKEN with the actual token
    });

    if (response.statusCode == 200) {
      final List<dynamic> extractedData = json.decode(response.body);
      print('VPNs data: $extractedData'); // Log the response data
      _vpns = extractedData.map((vpn) => Vpn.fromJson(vpn)).toList();
      notifyListeners();
    } else {
      print('Failed to load VPNs: ${response.body}'); // Log the error response
      throw Exception('Failed to load VPNs');
    }
  }
  
}
