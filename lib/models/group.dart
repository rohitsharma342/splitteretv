import 'user.dart';

class Group {
  final String id;
  final String name;
  final String? description;
  final List<User> members;
  final DateTime createdAt;
  final String? coverImage;
  
  Group({
    required this.id,
    required this.name,
    this.description,
    required this.members,
    required this.createdAt,
    this.coverImage,
  });
  
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      members: (json['members'] as List)
          .map((member) => User.fromJson(member))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      coverImage: json['coverImage'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'members': members.map((member) => member.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'coverImage': coverImage,
    };
  }
}