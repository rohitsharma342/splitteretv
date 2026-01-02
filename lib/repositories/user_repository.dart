import '../services/database_service.dart';
import '../models/user.dart';

class UserRepository {
  static Future<List<User>> getAllUsers() async {
    try {
      return await DatabaseService.fetchUsers();
    } catch (e) {
      print('UserRepository - Error getting all users: $e');
      rethrow;
    }
  }
  
  static Future<User?> getUserById(String id) async {
    try {
      return await DatabaseService.fetchUserById(id);
    } catch (e) {
      print('UserRepository - Error getting user by id: $e');
      rethrow;
    }
  }
  
  static Future<User> createUser(User user) async {
    try {
      return await DatabaseService.createUser(user);
    } catch (e) {
      print('UserRepository - Error creating user: $e');
      rethrow;
    }
  }
  
  static Future<User> updateUser(String id, User user) async {
    try {
      return await DatabaseService.updateUser(id, user);
    } catch (e) {
      print('UserRepository - Error updating user: $e');
      rethrow;
    }
  }
}