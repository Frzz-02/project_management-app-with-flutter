abstract interface class AuthenticationRemoteDataSource {
  Future<String> login(String email, String password);
}
