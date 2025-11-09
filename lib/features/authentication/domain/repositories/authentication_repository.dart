abstract interface class AuthenticationRepository {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> logout();
  Future<String> login(String email, String password);
}
