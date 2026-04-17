class User {
  final String id;
  final String empId;
  final String name;
  final String accessLevel;
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.empId,
    required this.name,
    required this.accessLevel,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      empId: json['emp_id'] ?? '',
      name: json['name'] ?? '',
      accessLevel: json['access_level'] ?? 'crewcontroller',
      lastLogin: json['last_login'] != null 
          ? DateTime.tryParse(json['last_login']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emp_id': empId,
      'name': name,
      'access_level': accessLevel,
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  bool get isAdmin => accessLevel == 'admin';
  bool get isCrewController => accessLevel == 'crewcontroller';
}

class AuthResult {
  final bool success;
  final User? user;
  final String? error;

  AuthResult({
    required this.success,
    this.user,
    this.error,
  });

  factory AuthResult.success(User user) {
    return AuthResult(success: true, user: user);
  }

  factory AuthResult.failure(String error) {
    return AuthResult(success: false, error: error);
  }
}
