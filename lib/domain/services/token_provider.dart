abstract class TokenProvider {
  Future<void> setToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}