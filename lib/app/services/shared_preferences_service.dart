import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String themeKey = 'theme_mode';

  static const String userTokenKey = 'user_token';

  static const String userIdKey = 'user_id';
  static const String isFirstTimeKey = 'is_first_time';
  static const String userProfileKey = 'user_profile';
  static const String languageKey = 'language';
  final SharedPreferences _prefs;
  SharedPreferencesService(this._prefs);

  Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  Future<bool> clearUserData() async {
    await _prefs.remove(userTokenKey);
    await _prefs.remove(userIdKey);
    await _prefs.remove(userProfileKey);
    return true;
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  bool getIsFirstTime() {
    return getBool(isFirstTimeKey) ?? true;
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  String? getUserId() {
    return getString(userIdKey);
  }

  String? getUserProfile() {
    return getString(userProfileKey);
  }

  String? getUserToken() {
    return getString(userTokenKey);
  }

  // Check if key exists
  bool hasKey(String key) {
    return _prefs.containsKey(key);
  }

  // Remove
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // Boolean operations
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  // Int operations
  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  Future<bool> setIsFirstTime(bool value) async {
    return await setBool(isFirstTimeKey, value);
  }

  // String operations
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  // List<String> operations
  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  Future<bool> setUserId(String id) async {
    return await setString(userIdKey, id);
  }

  Future<bool> setUserProfile(String profile) async {
    return await setString(userProfileKey, profile);
  }

  // Helper methods
  Future<bool> setUserToken(String token) async {
    return await setString(userTokenKey, token);
  }
}
