import 'package:project_management/features/authentication/data/data_sources/auth_local_data_source.dart';
import 'package:project_management/features/authentication/data/data_sources/authentication_remote_data_source.dart';

import '../../domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthLocalDataSource authLocalDataSource;
  final AuthenticationRemoteDataSource authRemoteDataSource;

  const AuthenticationRepositoryImpl({
    required this.authLocalDataSource,
    required this.authRemoteDataSource,
  });

  @override
  Future<void> saveToken(String token) async {
    await authLocalDataSource.cacheToken(token);
  }

  @override
  Future<String?> getToken() async {
    return await authLocalDataSource.getCacheToken();
  }

  @override
  Future<void> logout() async {
    await authLocalDataSource.clearToken();
  }

  @override
  Future<String> login(String email, String password) async {
    final token = await authRemoteDataSource.login(email, password);
    await saveToken(token);
    return token;
  }
}
