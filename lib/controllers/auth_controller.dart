import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/user.dart';

class AuthController extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String _error = '';
  bool _isAuthenticated = false;
  
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  
  AuthController() {
    _initializeAuth();
  }
  
  void _initializeAuth() {
    final user = SupabaseService.getCurrentUser();
    if (user != null) {
      _isAuthenticated = true;
      _loadCurrentUser(user.id);
    }
    
    // Listen to auth state changes
    SupabaseService.authStateChanges().listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      
      if (event == AuthChangeEvent.signedIn && session?.user != null) {
        _isAuthenticated = true;
        _loadCurrentUser(session!.user.id);
      } else if (event == AuthChangeEvent.signedOut) {
        _isAuthenticated = false;
        _currentUser = null;
        notifyListeners();
      }
    });
  }
  
  Future<void> _loadCurrentUser(String userId) async {
    try {
      final userData = await SupabaseService.fetchById('users', userId);
      if (userData != null) {
        _currentUser = User.fromJson(userData);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading current user: $e');
    }
  }
  
  Future<bool> signUp(String email, String password, String name) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();
      
      final response = await SupabaseService.signUp(email, password, name);
      
      if (response?.user != null) {
        _isAuthenticated = true;
        await _loadCurrentUser(response!.user!.id);
        return true;
      }
      
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();
      
      final response = await SupabaseService.signIn(email, password);
      
      if (response?.user != null) {
        _isAuthenticated = true;
        await _loadCurrentUser(response!.user!.id);
        return true;
      }
      
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await SupabaseService.signOut();
      
      _isAuthenticated = false;
      _currentUser = null;
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearError() {
    _error = '';
    notifyListeners();
  }
}