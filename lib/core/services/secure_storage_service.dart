import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // simpan token
  Future<void> saveToken(String? token) async {
    await _storage.write(key: 'token', value: token);
  }

  // ambil token
  Future<String?> getToken() {
    return _storage.read(key: 'token');
  }

  // hapus token
  Future<void> removeToken() {
    return _storage.delete(key: 'token');
  }
}
