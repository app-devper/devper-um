import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:common/app_config.dart';
import 'package:common/data/local/local_datasource.dart';
import 'package:common/data/network/custom_client.dart';
import 'package:common/data/network/http_logging_interceptor.dart';
import 'package:common/data/network/network_config.dart';
import 'package:common/data/session/app_session_provider.dart';
import 'package:common/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:um/data/datasource/local/local_datasource.dart';
import 'package:um/data/datasource/network/network_config.dart';
import 'package:um/data/datasource/network/um_service.dart';
import 'package:um/data/datasource/session/app_session.dart';
import 'package:um/data/repositories/login_repository_impl.dart';
import 'package:um/data/repositories/user_repository_impl.dart';
import 'package:um/domain/repositories/login_repository.dart';
import 'package:um/domain/repositories/user_repository.dart';
import 'package:um/domain/usecases/auth/fetch_token.dart';
import 'package:um/domain/usecases/auth/get_login.dart';
import 'package:um/domain/usecases/auth/get_role.dart';
import 'package:um/domain/usecases/auth/login_user.dart';
import 'package:um/domain/usecases/auth/logout_user.dart';
import 'package:um/domain/usecases/auth/get_system.dart';
import 'package:um/domain/usecases/user/change_password.dart';
import 'package:um/domain/usecases/user/create_user.dart';
import 'package:um/domain/usecases/user/get_user_by_id.dart';
import 'package:um/domain/usecases/user/get_user_info.dart';
import 'package:um/domain/usecases/user/get_users.dart';
import 'package:um/domain/usecases/user/remove_user_by_id.dart';
import 'package:um/domain/usecases/user/update_user_by_id.dart';
import 'package:um/domain/usecases/user/update_user_info.dart';
import 'package:um/presentation/error/error_view_model.dart';
import 'package:um/presentation/landing/landing_view_model.dart';
import 'package:um/presentation/login/login_view_model.dart';
import 'package:um/presentation/user/add/user_add_view_model.dart';
import 'package:um/presentation/user/change_password/change_password_view_model.dart';
import 'package:um/presentation/user/edit/user_edit_view_model.dart';
import 'package:um/presentation/user/info/user_info_view_model.dart';
import 'package:um/presentation/user/list/users_view_model.dart';
import 'package:um/presentation/user/main/user_home_view_model.dart';

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
  AppSession appSession = AppSession(sl());
  sl.registerLazySingleton<AppSessionProvider>(() => appSession);

  // Network
  sl.registerLazySingleton<NetworkConfig>(() => AppNetworkConfig(appSession: sl()));

  CustomClient client = CustomClient();
  client.addInterceptor(HttpLoggingInterceptor());
  sl.registerLazySingleton<CustomClient>(() => client);

  // LocalDataSource
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}

Future<void> initUm() async {
  // ViewModel
  sl.registerFactory(
    () => LoginViewModel(
      config: sl(),
      loginUserUseCase: sl(),
      fetchTokenUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => LandingViewModel(
      config: sl(),
      getSystemUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => UserHomeViewModel(
      logoutUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ChangePasswordViewModel(
      changePasswordUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => UsersViewModel(
      getUsersUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => UserInfoViewModel(
      getUserInfoUseCase: sl(),
      updateUserInfoUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => UserAddViewModel(
      createUserUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => UserEditViewModel(
      removeUserByIdUseCase: sl(),
      updateUserByIdUseCase: sl(),
      getUserByIdUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ErrorViewModel(
      logoutUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerFactory(() => LoginUser(repository: sl(), appSession: sl()));
  sl.registerFactory(() => GetLogin(repository: sl()));
  sl.registerFactory(() => GetRole(repository: sl()));
  sl.registerFactory(() => FetchToken(repository: sl(), appSession: sl()));
  sl.registerFactory(() => LogoutUser(repository: sl()));

  sl.registerFactory(() => GetSystem(repository: sl(), appSession: sl()));

  sl.registerFactory(() => GetUsers(repository: sl()));
  sl.registerFactory(() => GetUserInfo(repository: sl()));
  sl.registerFactory(() => UpdateUserInfo(repository: sl()));
  sl.registerFactory(() => GetUserById(repository: sl()));
  sl.registerFactory(() => UpdateUserById(repository: sl()));
  sl.registerFactory(() => RemoveUserById(repository: sl()));
  sl.registerFactory(() => CreateUser(repository: sl()));
  sl.registerFactory(() => ChangePassword(repository: sl()));

  // Repositories
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      service: sl(),
      localDataSource: sl(),
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
