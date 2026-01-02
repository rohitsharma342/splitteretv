import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;
  
  static SupabaseClient get client => _client;
  
  // Authentication methods
  static Future<AuthResponse?> signUp(String email, String password, String name) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      
      if (response.user != null) {
        await _saveUserToken(response.session?.accessToken);
        await _saveUserId(response.user!.id);
        
        // Create user profile in database
        await _client.from('users').insert({
          'id': response.user!.id,
          'name': name,
          'email': email,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
      
      return response;
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
  }
  
  static Future<AuthResponse?> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        await _saveUserToken(response.session?.accessToken);
        await _saveUserId(response.user!.id);
      }
      
      return response;
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }
  
  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      await _clearUserData();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }
  
  static User? getCurrentUser() {
    return _client.auth.currentUser;
  }
  
  static Stream<AuthState> authStateChanges() {
    return _client.auth.onAuthStateChange;
  }
  
  // Database CRUD operations
  static Future<List<Map<String, dynamic>>> fetchData(String table, {String? orderBy, bool ascending = true}) async {
    try {
      var query = _client.from(table).select();
      
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }
      
      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching data from $table: $e');
      rethrow;
    }
  }
  
  static Future<Map<String, dynamic>?> fetchById(String table, String id) async {
    try {
      final response = await _client
          .from(table)
          .select()
          .eq('id', id)
          .maybeSingle();
      
      return response;
    } catch (e) {
      print('Error fetching $table by id $id: $e');
      rethrow;
    }
  }
  
  static Future<Map<String, dynamic>> insertData(String table, Map<String, dynamic> data) async {
    try {
      data['created_at'] = DateTime.now().toIso8601String();
      data['updated_at'] = DateTime.now().toIso8601String();
      
      final response = await _client
          .from(table)
          .insert(data)
          .select()
          .single();
      
      return response;
    } catch (e) {
      print('Error inserting data into $table: $e');
      rethrow;
    }
  }
  
  static Future<Map<String, dynamic>> updateData(String table, String id, Map<String, dynamic> data) async {
    try {
      data['updated_at'] = DateTime.now().toIso8601String();
      
      final response = await _client
          .from(table)
          .update(data)
          .eq('id', id)
          .select()
          .single();
      
      return response;
    } catch (e) {
      print('Error updating data in $table: $e');
      rethrow;
    }
  }
  
  static Future<void> deleteData(String table, String id) async {
    try {
      await _client
          .from(table)
          .delete()
          .eq('id', id);
    } catch (e) {
      print('Error deleting data from $table: $e');
      rethrow;
    }
  }
  
  // Filtered queries
  static Future<List<Map<String, dynamic>>> fetchWithFilter(
    String table, 
    String column, 
    dynamic value, 
    {String? orderBy, bool ascending = true}
  ) async {
    try {
      var query = _client.from(table).select().eq(column, value);
      
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }
      
      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching filtered data from $table: $e');
      rethrow;
    }
  }
  
  // User token and ID management
  static Future<void> _saveUserToken(String? token) async {
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', token);
    }
  }
  
  static Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }
  
  static Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }
  
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }
  
  static Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user_id');
  }
}