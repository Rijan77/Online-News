class AuthTokenStorage {
  static String? _token = "rijan_123";

  static String? getToken() {
    return _token;
  }

  static void setToken(String token) {
    _token = token;
  }

  static void clearToken() {
    _token = null;
  }
}
