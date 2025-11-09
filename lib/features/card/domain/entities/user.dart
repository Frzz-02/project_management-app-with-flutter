/// User Entity
///
/// Entity untuk representasi data user di domain layer
/// Entity ini immutable dan hanya berisi business logic tanpa dependensi framework
///
class User {
  final int id;
  final String username;
  final String fullName;
  final String currentTaskStatus;
  final String email;
  final String role;
  final String? emailVerifiedAt;
  final String createdAt;

  const User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.currentTaskStatus,
    required this.email,
    required this.role,
    this.emailVerifiedAt,
    required this.createdAt,
  });
}
