import 'package:common/config/app_config.dart';
import 'package:common/core/network/custom_client.dart';
import 'package:common/core/network/http_logging_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:common/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:um/core/config/network_config.dart';
import 'package:um/data/datasource/local/local_datasource.dart';
import 'package:um/app_network_config.dart';
import 'package:um/data/datasource/network/um_service.dart';
import 'package:um/data/datasource/session/app_session.dart';
import 'package:um/data/repositories/login_repository_impl.dart';
import 'package:um/data/repositories/user_repository_impl.dart';
import 'package:um/domain/repositories/login_repository.dart';
import 'package:um/domain/repositories/user_repository.dart';

final sl = getIt(); // sl is referred to as Service Locator

void setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    if (kDebugMode) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    }
  });
}

// Dependency injection
Future<void> initCore(AppConfig config) async {
  // AppConfig
  sl.registerLazySingleton(() => config);

  // Session
  sl.registerLazySingleton<AppSession>(() =>  AppSession(sl()));

  // Network
  sl.registerLazySingleton<NetworkConfig>(() => AppNetworkConfig(appSession: sl()));

  CustomClient client = CustomClient();
  client.addInterceptor(HttpLoggingInterceptor());
  sl.registerLazySingleton<CustomClient>(() => client);

  // LocalDataSource
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSource(
      sharedPreferences: sl(),
    ),
  );

  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}

Future<void> initUm() async {
  // Repositories
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      service: sl(),
      localDataSource: sl(),
      appSession: sl(),
    ),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      service: sl(),
    ),
  );

  // Service
  sl.registerLazySingleton(
    () => UmService(
      networkConfig: sl(),
      client: sl(),
    ),
  );
}
