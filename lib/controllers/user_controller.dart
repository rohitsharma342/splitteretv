import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../services/supabase_service.dart';

class UserController extends ChangeNotifier {
  User? _currentUser;
  List<User> _users = [];
  bool _isLoading = false;
  String _error = '';
  
  User? get currentUser => _currentUser;
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String get error => _error;
  
  UserController() {
    loadUsers();
    _loadCurrentUser();
  }
  
  Future<void> _loadCurrentUser() async {
    try {
      final currentUserId = await SupabaseService.getUserId();
      if (currentUserId != null) {
        _currentUser = await UserRepository.getUserById(currentUserId);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading current user: $e');
    }
  }
  
  Future<void> loadUsers() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();
      
      _users = await UserRepository.getAllUsers();
    } catch (e) {
      _error = 'Failed to load users: $e';
      print('Error loading users: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    if (_currentUser == null) return;
    
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();
      
      final updatedUser = User(
        id: _currentUser!.id,
        name: name ?? _currentUser!.name,
        email: email ?? _currentUser!.email,
        phone: phone ?? _currentUser!.phone,
        avatar: _currentUser!.avatar,
        createdAt: _currentUser!.createdAt,
      );
      
      _currentUser = await UserRepository.updateUser(_currentUser!.id, updatedUser);
      
      // Update user in users list
      final index = _users.indexWhere((user) => user.id == _currentUser!.id);
      if (index != -1) {
        _users[index] = _currentUser!;
      }
    } catch (e) {
      _error = 'Failed to update profile: $e';
      print('Error updating profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await SupabaseService.signOut();
      
      _currentUser = null;
      _users.clear();
      _error = '';
    } catch (e) {
      _error = 'Failed to logout: $e';
      print('Error logging out: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  User? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }
  
  void clearError() {
    _error = '';
    notifyListeners();
  }
}