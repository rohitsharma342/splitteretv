import '../models/user.dart';
import '../models/group.dart';
import '../models/expense.dart';
import '../models/notification.dart';

class StaticDataService {
  static List<User> getUsers() {
    return [
      User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        phone: '+1234567890',
        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      User(
        id: '2',
        name: 'Jane Smith',
        email: 'jane@example.com',
        phone: '+1234567891',
        avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b37c?w=150&h=150&fit=crop&crop=face',
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      User(
        id: '3',
        name: 'Mike Johnson',
        email: 'mike@example.com',
        avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      User(
        id: '4',
        name: 'Sarah Wilson',
        email: 'sarah@example.com',
        avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }
  
  static List<Group> getGroups() {
    final users = getUsers();
    return [
      Group(
        id: '1',
        name: 'Roommates',
        description: 'Shared apartment expenses',
        members: [users[0], users[1], users[2]],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        coverImage: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400&h=200&fit=crop',
      ),
      Group(
        id: '2',
        name: 'Trip to Hawaii',
        description: 'Summer vacation expenses',
        members: [users[0], users[3]],
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        coverImage: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=200&fit=crop',
      ),
      Group(
        id: '3',
        name: 'Office Lunch',
        description: 'Team lunch expenses',
        members: users,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        coverImage: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&h=200&fit=crop',
      ),
    ];
  }
  
  static List<Expense> getExpenses() {
    final users = getUsers();
    return [
      Expense(
        id: '1',
        title: 'Grocery Shopping',
        amount: 120.50,
        category: 'Food & Dining',
        date: DateTime.now().subtract(const Duration(days: 2)),
        notes: 'Weekly grocery shopping',
        paidBy: users[0],
        splits: [
          ExpenseSplit(user: users[0], amount: 40.17),
          ExpenseSplit(user: users[1], amount: 40.17),
          ExpenseSplit(user: users[2], amount: 40.16),
        ],
        groupId: '1',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Expense(
        id: '2',
        title: 'Uber to Airport',
        amount: 45.00,
        category: 'Transportation',
        date: DateTime.now().subtract(const Duration(days: 1)),
        paidBy: users[1],
        splits: [
          ExpenseSplit(user: users[1], amount: 22.50),
          ExpenseSplit(user: users[0], amount: 22.50, isPaid: true),
        ],
        groupId: '2',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Expense(
        id: '3',
        title: 'Dinner at Restaurant',
        amount: 89.75,
        category: 'Food & Dining',
        date: DateTime.now().subtract(const Duration(hours: 6)),
        notes: 'Team dinner',
        paidBy: users[2],
        splits: [
          ExpenseSplit(user: users[0], amount: 22.44),
          ExpenseSplit(user: users[1], amount: 22.44),
          ExpenseSplit(user: users[2], amount: 22.44),
          ExpenseSplit(user: users[3], amount: 22.43),
        ],
        groupId: '3',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];
  }
  
  static List<AppNotification> getNotifications() {
    return [
      AppNotification(
        id: '1',
        title: 'Payment Received',
        message: 'John paid you \$22.50 for Uber to Airport',
        type: 'payment',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
        data: {'expenseId': '2', 'userId': '1', 'amount': 22.50},
      ),
      AppNotification(
        id: '2',
        title: 'New Expense Added',
        message: 'Mike added "Dinner at Restaurant" (\$89.75)',
        type: 'expense',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        isRead: true,
        data: {'expenseId': '3', 'userId': '3'},
      ),
      AppNotification(
        id: '3',
        title: 'Reminder',
        message: 'You owe Jane \$40.17 for Grocery Shopping',
        type: 'reminder',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: false,
        data: {'expenseId': '1', 'userId': '2', 'amount': 40.17},
      ),
    ];
  }
}