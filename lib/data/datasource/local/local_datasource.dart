import 'package:common/data/local/local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSourceImpl extends LocalDataSource {
  final String _cachedToken = 'CACHED_TOKEN';
  final SharedPreferences _sharedPreferences;

  LocalDataSourceImpl({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  Future<void> cacheToken(String accessToken) {
    return _sharedPreferences.setString(_cachedToken, accessToken);
  }

  @override
  Future<String> getLastToken() {
    String? jsonStr = _sharedPreferences.getString(_cachedToken);
    if (jsonStr == null) {
      return Future.value("");
    } else {
      return Future.value(jsonStr);
    }
  }

  @override
  Future<bool> clearToken() async {
    bool removed = await _sharedPreferences.remove(_cachedToken);
    return removed;
  }
}
