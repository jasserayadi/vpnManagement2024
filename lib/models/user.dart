class User {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String role;
  final List<String> vpnIds;
  final List<String> clientIds;

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
    required this.vpnIds,
    required this.clientIds,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      confirmPassword: json['confirmPassword'],
      role: json['role'],
      vpnIds: List<String>.from(json['vpns']),
      clientIds: List<String>.from(json['clients']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'role': role,
      'vpnIds': vpnIds,
      'clientIds': clientIds,
    };
  }
}
