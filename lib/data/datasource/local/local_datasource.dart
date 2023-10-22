import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<String> getToken();

  Future<void> cacheToken(String accessToken);

  Future<bool> clearToken();
}

class LocalDataSourceImpl extends LocalDataSource {
  final String _cachedToken = 'cached_token';
  final SharedPreferences _sharedPreferences;

  LocalDataSourceImpl({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  Future<void> cacheToken(String accessToken) {
    return _sharedPreferences.setString(_cachedToken, accessToken);
  }

  @override
  Future<String> getToken() {
    String? data = _sharedPreferences.getString(_cachedToken);
    if (data == null) {
      return Future.value("");
    } else {
      return Future.value(data);
    }
  }

  @override
  Future<bool> clearToken() async {
    bool removed = await _sharedPreferences.remove(_cachedToken);
    return removed;
  }
}
