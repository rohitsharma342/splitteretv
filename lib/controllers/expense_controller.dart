import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../models/user.dart';
import '../models/notification.dart';
import '../repositories/expense_repository.dart';

class ExpenseController extends ChangeNotifier {
  List<Expense> _expenses = [];
  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  String _error = '';
  
  List<Expense> get expenses => _expenses;
  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String get error => _error;
  
  List<AppNotification> get unreadNotifications =>
      _notifications.where((notification) => !notification.isRead).toList();
  
  ExpenseController() {
    loadExpenses();
    loadNotifications();
  }
  
  Future<void> loadExpenses() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();
      
      _expenses = await ExpenseRepository.getAllExpenses();
    } catch (e) {
      _error = 'Failed to load expenses: $e';
      print('Error loading expenses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> loadNotifications() async {
    try {
      _notifications = await ExpenseRepository.getAllNotifications();
      notifyListeners();
    } catch (e) {
      print('Error loading notifications: $e');
    }
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
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();
      
      final newExpense = Expense(
        id: '', // Will be set by database
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
      
      final createdExpense = await ExpenseRepository.createExpense(newExpense);
      _expenses.insert(0, createdExpense);
      
      // Add notification for new expense
      await _addNotification(
        title: 'New Expense Added',
        message: '${paidBy.name} added "$title" (\$${amount.toStringAsFixed(2)})',
        type: 'expense',
        data: {'expenseId': createdExpense.id, 'userId': paidBy.id},
      );
    } catch (e) {
      _error = 'Failed to add expense: $e';
      print('Error adding expense: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> _addNotification({
    required String title,
    required String message,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    try {
      final notification = AppNotification(
        id: '', // Will be set by database
        title: title,
        message: message,
        type: type,
        createdAt: DateTime.now(),
        data: data,
      );
      
      final createdNotification = await ExpenseRepository.createNotification(notification);
      _notifications.insert(0, createdNotification);
      notifyListeners();
    } catch (e) {
      print('Error adding notification: $e');
    }
  }
  
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final updatedNotification = _notifications[index].copyWith(isRead: true);
        await ExpenseRepository.updateNotification(notificationId, updatedNotification);
        _notifications[index] = updatedNotification;
        notifyListeners();
      }
    } catch (e) {
      print('Error marking notification as read: $e');
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
  
  void clearError() {
    _error = '';
    notifyListeners();
  }
}