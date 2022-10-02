
import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/model/system/system.dart';

abstract class LoginRepository {
  Future<Login> loginUser(LoginParam param);

  Future<Login> keepAlive();

  Future<bool> logoutUser();

  Future<String> getRole();

  Future<String> getToken();

  Future<System> getSystem();
}
