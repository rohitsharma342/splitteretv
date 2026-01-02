import 'package:flutter/foundation.dart';
import '../models/group.dart';
import '../models/user.dart';
import '../services/static_data_service.dart';

class GroupController extends ChangeNotifier {
  List<Group> _groups = [];
  bool _isLoading = false;
  String _searchQuery = '';
  
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
  
  GroupController() {
    _loadGroups();
  }
  
  void _loadGroups() {
    _isLoading = true;
    notifyListeners();
    
    _groups = StaticDataService.getGroups();
    
    _isLoading = false;
    notifyListeners();
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
    _isLoading = true;
    notifyListeners();
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    final newGroup = Group(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      members: members,
      createdAt: DateTime.now(),
    );
    
    _groups.add(newGroup);
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> inviteMember(String groupId, String email) async {
    _isLoading = true;
    notifyListeners();
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    // In a real app, this would send an invitation
    // For now, we'll just simulate success
    
    _isLoading = false;
    notifyListeners();
  }
  
  Group? getGroupById(String id) {
    try {
      return _groups.firstWhere((group) => group.id == id);
    } catch (e) {
      return null;
    }
  }
  
  List<Group> getUserGroups(String userId) {
    return _groups
        .where((group) => group.members.any((member) => member.id == userId))
        .toList();
  }
}