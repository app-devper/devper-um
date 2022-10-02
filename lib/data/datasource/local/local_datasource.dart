import 'package:common/data/local/local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSourceImpl extends LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheToken(String accessToken) {
    return sharedPreferences.setString(CACHED_TOKEN, accessToken);
  }

  @override
  Future<String> getLastToken() {
    String? jsonStr = sharedPreferences.getString(CACHED_TOKEN);
    if (jsonStr == null) {
      return Future.value("");
    } else {
      return Future.value(jsonStr);
    }
  }

  @override
  Future<bool> clearToken() async {
    bool removed = await sharedPreferences.remove(CACHED_TOKEN);
    return removed;
  }
}

const String CACHED_TOKEN = 'CACHED_TOKEN';
