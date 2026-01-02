import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../models/user.dart';
import '../models/notification.dart';
import '../services/static_data_service.dart';

class ExpenseController extends ChangeNotifier {
  List<Expense> _expenses = [];
  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  
  List<Expense> get expenses => _expenses;
  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  
  List<AppNotification> get unreadNotifications =>
      _notifications.where((notification) => !notification.isRead).toList();
  
  ExpenseController() {
    _loadExpenses();
    _loadNotifications();
  }
  
  void _loadExpenses() {
    _isLoading = true;
    notifyListeners();
    
    _expenses = StaticDataService.getExpenses();
    
    _isLoading = false;
    notifyListeners();
  }
  
  void _loadNotifications() {
    _notifications = StaticDataService.getNotifications();
    notifyListeners();
  }
  
  Future<void> addExpense({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    String? notes,
    required User paidBy,
    required List<ExpenseSplit> splits,
    String? groupId,
  }) async {
    _isLoading = true;
    notifyListeners();
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    final newExpense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      category: category,
      date: date,
      notes: notes,
      paidBy: paidBy,
      splits: splits,
      groupId: groupId,
      createdAt: DateTime.now(),
    );
    
    _expenses.insert(0, newExpense);
    
    // Add notification for new expense
    _addNotification(
      title: 'New Expense Added',
      message: '${paidBy.name} added "$title" (\$${amount.toStringAsFixed(2)})',
      type: 'expense',
      data: {'expenseId': newExpense.id, 'userId': paidBy.id},
    );
    
    _isLoading = false;
    notifyListeners();
  }
  
  void _addNotification({
    required String title,
    required String message,
    required String type,
    Map<String, dynamic>? data,
  }) {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      createdAt: DateTime.now(),
      data: data,
    );
    
    _notifications.insert(0, notification);
  }
  
  void markNotificationAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }
  
  List<Expense> getExpensesByGroup(String groupId) {
    return _expenses.where((expense) => expense.groupId == groupId).toList();
  }
  
  List<Expense> getRecentExpenses({int limit = 5}) {
    final sorted = List<Expense>.from(_expenses)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(limit).toList();
  }
  
  double getTotalOwed(String userId) {
    double total = 0.0;
    for (final expense in _expenses) {
      if (expense.paidBy.id != userId) {
        final split = expense.splits.firstWhere(
          (split) => split.user.id == userId,
          orElse: () => ExpenseSplit(user: expense.splits.first.user, amount: 0),
        );
        if (!split.isPaid) {
          total += split.amount;
        }
      }
    }
    return total;
  }
  
  double getTotalOwedTo(String userId) {
    double total = 0.0;
    for (final expense in _expenses) {
      if (expense.paidBy.id == userId) {
        for (final split in expense.splits) {
          if (split.user.id != userId && !split.isPaid) {
            total += split.amount;
          }
        }
      }
    }
    return total;
  }
  
  Map<String, double> getGroupBalances(String groupId) {
    final groupExpenses = getExpensesByGroup(groupId);
    final balances = <String, double>{};
    
    for (final expense in groupExpenses) {
      for (final split in expense.splits) {
        final userId = split.user.id;
        balances[userId] = (balances[userId] ?? 0.0) - split.amount;
        
        if (expense.paidBy.id == userId) {
          balances[userId] = (balances[userId] ?? 0.0) + expense.amount;
        }
      }
    }
    
    return balances;
  }
}