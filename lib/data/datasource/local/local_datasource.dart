import 'package:shared_preferences/shared_preferences.dart';


class LocalDataSource {
  final String _cachedToken = 'cached_token';
  final SharedPreferences _sharedPreferences;

  LocalDataSource({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  Future<void> cacheToken(String accessToken) {
    return _sharedPreferences.setString(_cachedToken, accessToken);
  }

  Future<String> getToken() {
    String? data = _sharedPreferences.getString(_cachedToken);
    if (data == null) {
      return Future.value("");
    } else {
      return Future.value(data);
    }
  }

  Future<bool> clearToken() async {
    bool removed = await _sharedPreferences.remove(_cachedToken);
    return removed;
  }
}
