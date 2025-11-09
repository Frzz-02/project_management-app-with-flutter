abstract interface class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getCacheToken();
  Future<void> clearToken();
}
