import 'package:project_management/core/services/secure_storage_service.dart';

import 'auth_local_data_source.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService storageService;
  const AuthLocalDataSourceImpl(this.storageService);

  @override
  Future<void> cacheToken(String token) async {
    await storageService.saveToken(token);
  }

  @override
  Future<String?> getCacheToken() async {
    return await storageService.getToken();
  }

  @override
  Future<void> clearToken() async {
    await storageService.removeToken();
  }
}
