import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> setToken(String token) async {
    await _prefs?.setString('token', token);
  }

  static String? getToken() {
    return _prefs?.getString('token');
  }

  static Future<bool> clear() async {
    await _prefs?.clear();
    return true;
  }
}
