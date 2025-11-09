import '../../domain/entities/authentication.dart';

class AuthenticationModel extends Authentication {
  AuthenticationModel({required super.email, required super.password});

  factory AuthenticationModel.fromMap(Map<String, dynamic> credential) {
    return AuthenticationModel(
      email: credential['email'] as String,
      password: credential['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
