import '../repositories/authentication_repository.dart';

class GetLoginTokenUseCase {
  final AuthenticationRepository _repository;

  GetLoginTokenUseCase({required AuthenticationRepository repository})
    : _repository = repository;

  Future<String?> call() async {
    return _repository.getToken();
  }
}
