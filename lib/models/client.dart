class Client {
  String? id;
  int? clientId;
  String? clientName;
  String? email;
  String? numero;
  DateTime? createdAt;
  String? userId;
  List<String>? vpns;

  Client({
    this.id,
    this.clientId,
    this.clientName,
    this.email,
    this.numero,
    this.createdAt,
    this.userId,
    this.vpns,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['_id'] as String?,
      clientId: json['clientId'] as int?,
      clientName: json['clientName'] as String?,
      email: json['email'] as String?,
      numero: json['numero'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      userId: json['userId'] as String?,
      vpns: (json['vpns'] as List<dynamic>?)?.map((vpn) => vpn as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'clientId': clientId,
      'clientName': clientName,
      'email': email,
      'numero': numero,
      'createdAt': createdAt?.toIso8601String(),
      'userId': userId,
      'vpns': vpns,
    };
  }
}
