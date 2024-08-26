import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static const String _emailKey = 'user_email';
  static const String _passwordKey = 'user_password';

  Future<String?> getStoredEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }
  Future<void> setEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_emailKey, email);
  }

  Future<String?> getStoredPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passwordKey);
  }

  Future<void> saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_emailKey, email);
    prefs.setString(_passwordKey, password);
  }

  Future<void> removeCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_passwordKey);
  }
}