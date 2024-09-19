import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class AuthService {
  final String baseUrl = 'http://localhost:3001/auth';//final String baseUrl = 'http://10.0.2.2:3001/auth';
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<User?> register(String username, String email, String password,
      String confirmPassword, String role) async {
    print('Registering user with:');
    print('Username: $username');
    print('Email: $email');
    print('Password: $password');
    print('Confirm Password: $confirmPassword');
    print('Role: $role');

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'role': role,
      }),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to register user');
    }
  }

  Future<String?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = jsonDecode(response.body)['access_token'];
        await storage.write(key: 'jwt_token', value: token);
        return token;
      } else {
        print('Failed to login: ${response.body}');
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Failed to login');
    }
  }

  Future<User?> getUserById(String userId) async {
    final token = await storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('http://localhost:3001/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

Future<void> logout() async {
  try {
    // Retrieve the token
    final token = await storage.read(key: 'jwt_token');
    
    if (token == null) {
      throw Exception('No token found');
    }
    
    // Call the backend to invalidate the token
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'token': token}), // Send the token in the request body
    );
    
    if (response.statusCode == 200) {
      // Clear the stored token upon successful logout
      await storage.delete(key: 'jwt_token');
      print('User successfully logged out.');
    } else if (response.statusCode != 200 && response.body != '{"message":"Successfully logged out"}') {
      print('Failed to logout: ${response.body}'); // Add the closing brace here
      throw Exception('Failed to logout');
    }
  } catch (e) {
    print('Error during logout: $e');
    // Check if the error message is "Successfully logged out"
    if (e.toString().contains('Successfully logged out')) {
      return; // Return without throwing an exception
    }
    throw Exception('Failed to logout');
  }
}
}
