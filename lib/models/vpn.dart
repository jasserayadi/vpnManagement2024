class Vpn {
  String id;
  String description;
  String url;
  String port;
  String pwd;
  String address;
  String userId;
  List<String> clients;

  Vpn({
    required this.id,
    required this.description,
    required this.url,
    required this.port,
    required this.pwd,
    required this.address,
    required this.userId,
    required this.clients,
  });

  factory Vpn.fromJson(Map<String, dynamic> json) {
    return Vpn(
      id: json['_id'],
      description: json['description'],
      url: json['url'],
      port: json['port'],
      pwd: json['pwd'],
      address: json['address'],
      userId: json['userId'],
      clients: List<String>.from(json['clients'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'description': description,
      'url': url,
      'port': port,
      'pwd': pwd,
      'address': address,
      'userId': userId,
      'clients': clients,
    };
  }
}
