import '../services/database_service.dart';
import '../models/expense.dart';
import '../models/notification.dart';

class ExpenseRepository {
  static Future<List<Expense>> getAllExpenses() async {
    try {
      return await DatabaseService.fetchExpenses();
    } catch (e) {
      print('ExpenseRepository - Error getting all expenses: $e');
      rethrow;
    }
  }
  
  static Future<List<Expense>> getExpensesByGroup(String groupId) async {
    try {
      return await DatabaseService.fetchExpensesByGroup(groupId);
    } catch (e) {
      print('ExpenseRepository - Error getting expenses by group: $e');
      rethrow;
    }
  }
  
  static Future<Expense> createExpense(Expense expense) async {
    try {
      return await DatabaseService.createExpense(expense);
    } catch (e) {
      print('ExpenseRepository - Error creating expense: $e');
      rethrow;
    }
  }
  
  static Future<List<AppNotification>> getAllNotifications() async {
    try {
      return await DatabaseService.fetchNotifications();
    } catch (e) {
      print('ExpenseRepository - Error getting all notifications: $e');
      rethrow;
    }
  }
  
  static Future<AppNotification> createNotification(AppNotification notification) async {
    try {
      return await DatabaseService.createNotification(notification);
    } catch (e) {
      print('ExpenseRepository - Error creating notification: $e');
      rethrow;
    }
  }
  
  static Future<AppNotification> updateNotification(String id, AppNotification notification) async {
    try {
      return await DatabaseService.updateNotification(id, notification);
    } catch (e) {
      print('ExpenseRepository - Error updating notification: $e');
      rethrow;
    }
  }
}