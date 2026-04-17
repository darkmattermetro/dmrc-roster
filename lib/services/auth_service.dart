import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/user.dart' as models;

class AuthResult {
  final bool success;
  final String message;
  final models.User? user;

  AuthResult._({required this.success, required this.message, this.user});

  factory AuthResult.success(models.User user) {
    return AuthResult._(success: true, message: 'Success', user: user);
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(success: false, message: message);
  }

  String get error => message;
}

class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<AuthResult> login(String empId, String password) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('emp_id', empId.toUpperCase())
          .maybeSingle();

      if (response == null) {
        return AuthResult.failure('Emp ID not found. Please register first.');
      }

      final storedHash = response['password_hash'] ?? '';
      final inputHash = _hashPassword(password);

      if (storedHash != inputHash) {
        return AuthResult.failure('Invalid password');
      }

      await _client
          .from('profiles')
          .update({'last_login': DateTime.now().toIso8601String()}).eq(
              'emp_id', empId.toUpperCase());

      return AuthResult.success(models.User.fromJson(response));
    } catch (e) {
      return AuthResult.failure('Login failed: ${e.toString()}');
    }
  }

  Future<AuthResult> register({
    required String empId,
    required String name,
    required String password,
    required String accessCode,
    required String accessLevel,
  }) async {
    try {
      if (accessCode != 'satvik') {
        return AuthResult.failure('Invalid Access Code');
      }

      final allowedTable = accessLevel == 'admin'
          ? 'allowed_admins'
          : 'allowed_crew_controllers';

      final allowed = await _client
          .from(allowedTable)
          .select()
          .eq('emp_id', empId.toUpperCase())
          .maybeSingle();

      if (allowed == null) {
        return AuthResult.failure('Emp ID not authorized for $accessLevel');
      }

      final existing = await _client
          .from('profiles')
          .select()
          .eq('emp_id', empId.toUpperCase())
          .maybeSingle();

      if (existing != null) {
        return AuthResult.failure('Emp ID already registered');
      }

      await _client.from('profiles').insert({
        'emp_id': empId.toUpperCase(),
        'name': name,
        'password_hash': _hashPassword(password),
        'access_level': accessLevel,
      });

      final newUser = await _client
          .from('profiles')
          .select()
          .eq('emp_id', empId.toUpperCase())
          .maybeSingle();

      if (newUser != null) {
        return AuthResult.success(models.User.fromJson(newUser));
      }

      return AuthResult.failure('Registration failed');
    } catch (e) {
      return AuthResult.failure('Registration failed: ${e.toString()}');
    }
  }

  Future<models.User?> getCurrentUser() async {
    final session = _client.auth.currentSession;
    if (session == null) return null;

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', session.user!.id)
        .maybeSingle();

    if (response != null) {
      return models.User.fromJson(response);
    }
    return null;
  }

  Future<bool> checkIsAdmin(String empId) async {
    final response = await _client
        .from('allowed_admins')
        .select()
        .eq('emp_id', empId.toUpperCase())
        .maybeSingle();
    return response != null;
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  String _hashPassword(String password) {
    var hash = 0;
    for (var i = 0; i < password.length; i++) {
      var char = password.codeUnitAt(i);
      hash = ((hash << 5) - hash) + char;
      hash = hash & hash;
    }
    return hash.toString();
  }
}
