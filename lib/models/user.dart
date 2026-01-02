class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final DateTime createdAt;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    required this.createdAt,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}