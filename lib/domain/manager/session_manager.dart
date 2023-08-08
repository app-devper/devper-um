
import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/model/auth/system.dart';

abstract class SessionManager {
  Future<void> clearAppSession();
  Future<void> setLogin(Login data);
  Future<void> setSystem(System data);
}
