import '../../domain/entities/user.dart';

/// User Model
///
/// Model untuk mapping data user dari/ke JSON
/// Extends dari User entity dan menambahkan factory method untuk parsing
///
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.fullName,
    required super.currentTaskStatus,
    required super.email,
    required super.role,
    super.emailVerifiedAt,
    required super.createdAt,
  });

  /// Factory method untuk membuat UserModel dari Map (JSON)
  ///
  /// [json] adalah Map yang berisi data user dari API response
  /// Returns UserModel instance
  ///
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      currentTaskStatus: json['current_task_status'] as String? ?? 'idle',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'member',
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  /// Method untuk convert UserModel ke Map (JSON)
  ///
  /// Returns Map<String, dynamic> yang siap dikirim ke API
  ///
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'current_task_status': currentTaskStatus,
      'email': email,
      'role': role,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
    };
  }
}
