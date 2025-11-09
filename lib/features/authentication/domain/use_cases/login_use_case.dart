import 'package:project_management/features/authentication/domain/entities/authentication.dart';

import '../repositories/authentication_repository.dart';

class LoginUseCase {
  final AuthenticationRepository _repository;

  LoginUseCase({required AuthenticationRepository repository})
    : _repository = repository;

  Future<void> call(Authentication credential) async {
    await _repository.login(credential.email, credential.password);
  }
}
