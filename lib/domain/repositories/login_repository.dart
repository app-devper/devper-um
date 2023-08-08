
import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/model/auth/system.dart';

abstract class LoginRepository {
  Future<Login> loginUser(LoginParam param);

  Future<Login> keepAlive(String accessToken);

  Future<bool> logoutUser();

  Future<String> getRole();

  Future<String> getToken();

  Future<System> getSystem();
}
