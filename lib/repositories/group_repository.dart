import '../services/database_service.dart';
import '../models/group.dart';

class GroupRepository {
  static Future<List<Group>> getAllGroups() async {
    try {
      return await DatabaseService.fetchGroups();
    } catch (e) {
      print('GroupRepository - Error getting all groups: $e');
      rethrow;
    }
  }
  
  static Future<Group?> getGroupById(String id) async {
    try {
      return await DatabaseService.fetchGroupById(id);
    } catch (e) {
      print('GroupRepository - Error getting group by id: $e');
      rethrow;
    }
  }
  
  static Future<List<Group>> getUserGroups(String userId) async {
    try {
      return await DatabaseService.fetchUserGroups(userId);
    } catch (e) {
      print('GroupRepository - Error getting user groups: $e');
      rethrow;
    }
  }
  
  static Future<Group> createGroup(Group group) async {
    try {
      return await DatabaseService.createGroup(group);
    } catch (e) {
      print('GroupRepository - Error creating group: $e');
      rethrow;
    }
  }
}