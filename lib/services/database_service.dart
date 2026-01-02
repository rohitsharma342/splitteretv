import '../services/supabase_service.dart';
import '../models/user.dart';
import '../models/group.dart';
import '../models/expense.dart';
import '../models/notification.dart';

class DatabaseService {
  // User operations
  static Future<List<User>> fetchUsers() async {
    try {
      final data = await SupabaseService.fetchData('users', orderBy: 'created_at');
      return data.map((item) => User.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching users: $e');
      rethrow;
    }
  }
  
  static Future<User?> fetchUserById(String id) async {
    try {
      final data = await SupabaseService.fetchById('users', id);
      return data != null ? User.fromJson(data) : null;
    } catch (e) {
      print('Error fetching user by id: $e');
      rethrow;
    }
  }
  
  static Future<User> createUser(User user) async {
    try {
      final data = await SupabaseService.insertData('users', user.toJson());
      return User.fromJson(data);
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }
  
  static Future<User> updateUser(String id, User user) async {
    try {
      final data = await SupabaseService.updateData('users', id, user.toJson());
      return User.fromJson(data);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }
  
  // Group operations
  static Future<List<Group>> fetchGroups() async {
    try {
      final data = await SupabaseService.fetchData('groups', orderBy: 'created_at', ascending: false);
      final groups = <Group>[];
      
      for (final item in data) {
        final memberIds = List<String>.from(item['member_ids'] ?? []);
        final members = <User>[];
        
        for (final memberId in memberIds) {
          final user = await fetchUserById(memberId);
          if (user != null) {
            members.add(user);
          }
        }
        
        final group = Group(
          id: item['id'],
          name: item['name'],
          description: item['description'],
          members: members,
          createdAt: DateTime.parse(item['created_at']),
          coverImage: item['cover_image'],
        );
        
        groups.add(group);
      }
      
      return groups;
    } catch (e) {
      print('Error fetching groups: $e');
      rethrow;
    }
  }
  
  static Future<Group?> fetchGroupById(String id) async {
    try {
      final data = await SupabaseService.fetchById('groups', id);
      if (data == null) return null;
      
      final memberIds = List<String>.from(data['member_ids'] ?? []);
      final members = <User>[];
      
      for (final memberId in memberIds) {
        final user = await fetchUserById(memberId);
        if (user != null) {
          members.add(user);
        }
      }
      
      return Group(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        members: members,
        createdAt: DateTime.parse(data['created_at']),
        coverImage: data['cover_image'],
      );
    } catch (e) {
      print('Error fetching group by id: $e');
      rethrow;
    }
  }
  
  static Future<Group> createGroup(Group group) async {
    try {
      final groupData = {
        'name': group.name,
        'description': group.description,
        'member_ids': group.members.map((member) => member.id).toList(),
        'cover_image': group.coverImage,
      };
      
      final data = await SupabaseService.insertData('groups', groupData);
      
      return Group(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        members: group.members,
        createdAt: DateTime.parse(data['created_at']),
        coverImage: data['cover_image'],
      );
    } catch (e) {
      print('Error creating group: $e');
      rethrow;
    }
  }
  
  static Future<List<Group>> fetchUserGroups(String userId) async {
    try {
      final data = await SupabaseService.fetchData('groups');
      final userGroups = <Group>[];
      
      for (final item in data) {
        final memberIds = List<String>.from(item['member_ids'] ?? []);
        
        if (memberIds.contains(userId)) {
          final members = <User>[];
          
          for (final memberId in memberIds) {
            final user = await fetchUserById(memberId);
            if (user != null) {
              members.add(user);
            }
          }
          
          final group = Group(
            id: item['id'],
            name: item['name'],
            description: item['description'],
            members: members,
            createdAt: DateTime.parse(item['created_at']),
            coverImage: item['cover_image'],
          );
          
          userGroups.add(group);
        }
      }
      
      return userGroups;
    } catch (e) {
      print('Error fetching user groups: $e');
      rethrow;
    }
  }
  
  // Expense operations
  static Future<List<Expense>> fetchExpenses() async {
    try {
      final data = await SupabaseService.fetchData('expenses', orderBy: 'created_at', ascending: false);
      final expenses = <Expense>[];
      
      for (final item in data) {
        final paidBy = await fetchUserById(item['paid_by_id']);
        if (paidBy == null) continue;
        
        final splitsData = List<Map<String, dynamic>>.from(item['splits'] ?? []);
        final splits = <ExpenseSplit>[];
        
        for (final splitData in splitsData) {
          final user = await fetchUserById(splitData['user_id']);
          if (user != null) {
            splits.add(ExpenseSplit(
              user: user,
              amount: (splitData['amount'] as num).toDouble(),
              isPaid: splitData['is_paid'] ?? false,
            ));
          }
        }
        
        final expense = Expense(
          id: item['id'],
          title: item['title'],
          amount: (item['amount'] as num).toDouble(),
          category: item['category'],
          date: DateTime.parse(item['expense_date']),
          notes: item['notes'],
          paidBy: paidBy,
          splits: splits,
          groupId: item['group_id'],
          createdAt: DateTime.parse(item['created_at']),
        );
        
        expenses.add(expense);
      }
      
      return expenses;
    } catch (e) {
      print('Error fetching expenses: $e');
      rethrow;
    }
  }
  
  static Future<List<Expense>> fetchExpensesByGroup(String groupId) async {
    try {
      final data = await SupabaseService.fetchWithFilter(
        'expenses', 
        'group_id', 
        groupId,
        orderBy: 'created_at',
        ascending: false,
      );
      
      final expenses = <Expense>[];
      
      for (final item in data) {
        final paidBy = await fetchUserById(item['paid_by_id']);
        if (paidBy == null) continue;
        
        final splitsData = List<Map<String, dynamic>>.from(item['splits'] ?? []);
        final splits = <ExpenseSplit>[];
        
        for (final splitData in splitsData) {
          final user = await fetchUserById(splitData['user_id']);
          if (user != null) {
            splits.add(ExpenseSplit(
              user: user,
              amount: (splitData['amount'] as num).toDouble(),
              isPaid: splitData['is_paid'] ?? false,
            ));
          }
        }
        
        final expense = Expense(
          id: item['id'],
          title: item['title'],
          amount: (item['amount'] as num).toDouble(),
          category: item['category'],
          date: DateTime.parse(item['expense_date']),
          notes: item['notes'],
          paidBy: paidBy,
          splits: splits,
          groupId: item['group_id'],
          createdAt: DateTime.parse(item['created_at']),
        );
        
        expenses.add(expense);
      }
      
      return expenses;
    } catch (e) {
      print('Error fetching expenses by group: $e');
      rethrow;
    }
  }
  
  static Future<Expense> createExpense(Expense expense) async {
    try {
      final expenseData = {
        'title': expense.title,
        'amount': expense.amount,
        'category': expense.category,
        'expense_date': expense.date.toIso8601String(),
        'notes': expense.notes,
        'paid_by_id': expense.paidBy.id,
        'group_id': expense.groupId,
        'splits': expense.splits.map((split) => {
          'user_id': split.user.id,
          'amount': split.amount,
          'is_paid': split.isPaid,
        }).toList(),
      };
      
      final data = await SupabaseService.insertData('expenses', expenseData);
      
      return Expense(
        id: data['id'],
        title: data['title'],
        amount: (data['amount'] as num).toDouble(),
        category: data['category'],
        date: DateTime.parse(data['expense_date']),
        notes: data['notes'],
        paidBy: expense.paidBy,
        splits: expense.splits,
        groupId: data['group_id'],
        createdAt: DateTime.parse(data['created_at']),
      );
    } catch (e) {
      print('Error creating expense: $e');
      rethrow;
    }
  }
  
  // Notification operations
  static Future<List<AppNotification>> fetchNotifications() async {
    try {
      final data = await SupabaseService.fetchData('notifications', orderBy: 'created_at', ascending: false);
      return data.map((item) => AppNotification.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      rethrow;
    }
  }
  
  static Future<AppNotification> createNotification(AppNotification notification) async {
    try {
      final data = await SupabaseService.insertData('notifications', notification.toJson());
      return AppNotification.fromJson(data);
    } catch (e) {
      print('Error creating notification: $e');
      rethrow;
    }
  }
  
  static Future<AppNotification> updateNotification(String id, AppNotification notification) async {
    try {
      final data = await SupabaseService.updateData('notifications', id, notification.toJson());
      return AppNotification.fromJson(data);
    } catch (e) {
      print('Error updating notification: $e');
      rethrow;
    }
  }
}