class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;
  
  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });
  
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'] ?? false,
      data: json['data'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'data': data,
    };
  }
  
  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    DateTime? createdAt,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }
}