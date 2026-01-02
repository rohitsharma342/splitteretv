import 'user.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? notes;
  final User paidBy;
  final List<ExpenseSplit> splits;
  final String? groupId;
  final DateTime createdAt;
  
  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.notes,
    required this.paidBy,
    required this.splits,
    this.groupId,
    required this.createdAt,
  });
  
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
      paidBy: User.fromJson(json['paidBy']),
      splits: (json['splits'] as List)
          .map((split) => ExpenseSplit.fromJson(split))
          .toList(),
      groupId: json['groupId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'notes': notes,
      'paidBy': paidBy.toJson(),
      'splits': splits.map((split) => split.toJson()).toList(),
      'groupId': groupId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class ExpenseSplit {
  final User user;
  final double amount;
  final bool isPaid;
  
  ExpenseSplit({
    required this.user,
    required this.amount,
    this.isPaid = false,
  });
  
  factory ExpenseSplit.fromJson(Map<String, dynamic> json) {
    return ExpenseSplit(
      user: User.fromJson(json['user']),
      amount: json['amount'].toDouble(),
      isPaid: json['isPaid'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'amount': amount,
      'isPaid': isPaid,
    };
  }
}