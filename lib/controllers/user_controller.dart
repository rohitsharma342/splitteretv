import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/static_data_service.dart';

class UserController extends ChangeNotifier {
  User? _currentUser;
  List<User> _users = [];
  bool _isLoading = false;
  
  User? get currentUser => _currentUser;
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  
  UserController() {
    _loadUsers();
    _setCurrentUser();
  }
  
  void _loadUsers() {
    _isLoading = true;
    notifyListeners();
    
    _users = StaticDataService.getUsers();
    
    _isLoading = false;
    notifyListeners();
  }
  
  void _setCurrentUser() {
    if (_users.isNotEmpty) {
      _currentUser = _users.first;
      notifyListeners();
    }
  }
  
  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    if (_currentUser == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = User(
      id: _currentUser!.id,
      name: name ?? _currentUser!.name,
      email: email ?? _currentUser!.email,
      phone: phone ?? _currentUser!.phone,
      avatar: _currentUser!.avatar,
      createdAt: _currentUser!.createdAt,
    );
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    // Simulate logout process
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = null;
    _users.clear();
    
    _isLoading = false;
    notifyListeners();
  }
  
  User? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }
}