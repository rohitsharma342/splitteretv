import 'package:flutter/foundation.dart';
import '../models/group.dart';
import '../models/user.dart';
import '../repositories/group_repository.dart';

class GroupController extends ChangeNotifier {
  List<Group> _groups = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _error = '';
  
  List<Group> get groups {
    if (_searchQuery.isEmpty) {
      return _groups;
    }
    return _groups
        .where((group) =>
            group.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            group.description?.toLowerCase().contains(_searchQuery.toLowerCase()) == true)
        .toList();
  }
  
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get error => _error;
  
  GroupController() {
    loadGroups();
  }
  
  Future<void> loadGroups() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();
      
      _groups = await GroupRepository.getAllGroups();
    } catch (e) {
      _error = 'Failed to load groups: $e';
      print('Error loading groups: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  Future<void> createGroup({
    required String name,
    String? description,
    required List<User> members,
  }) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();
      
      final newGroup = Group(
        id: '', // Will be set by database
        name: name,
        description: description,
        members: members,
        createdAt: DateTime.now(),
      );
      
      final createdGroup = await GroupRepository.createGroup(newGroup);
      _groups.add(createdGroup);
    } catch (e) {
      _error = 'Failed to create group: $e';
      print('Error creating group: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> inviteMember(String groupId, String email) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();
      
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // In a real app, this would send an invitation
      // For now, we'll just simulate success
    } catch (e) {
      _error = 'Failed to invite member: $e';
      print('Error inviting member: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Group? getGroupById(String id) {
    try {
      return _groups.firstWhere((group) => group.id == id);
    } catch (e) {
      return null;
    }
  }
  
  Future<List<Group>> getUserGroups(String userId) async {
    try {
      return await GroupRepository.getUserGroups(userId);
    } catch (e) {
      print('Error getting user groups: $e');
      return [];
    }
  }
  
  void clearError() {
    _error = '';
    notifyListeners();
  }
}