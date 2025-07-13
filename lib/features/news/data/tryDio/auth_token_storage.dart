class AuthTokenStorage {
  static String? _token = "rijan_123";

  static String? getToken() {
    return _token;
  }

  static  setToken(String token) {
    _token = token;
  }

  static  clearToken() {
    _token = null;
  }
}
