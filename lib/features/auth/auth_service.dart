class AuthService {
  // TEMP in-memory users (replace with backend later)
  static final Map<String, String> _users = {};

  Future<bool> signup(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_users.containsKey(email)) return false;
    _users[email] = password;
    return true;
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return _users[email] == password;
  }
}
