import 'package:common/core/error/exception.dart';
import 'package:common/core/error/failures.dart';
import 'package:common/core/result/result.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:um/domain/manager/session_manager.dart';
import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/repositories/login_repository.dart';

class LoginUser implements BaseUseCaseParam<LoginParam, Login> {
  final LoginRepository repository;
  final SessionManager manager;

  LoginUser({
    required this.repository,
    required this.manager,
  });

  @override
  FutureResult<Login, Failure> call(LoginParam param) async {
    try {
      if (param.password.isEmpty || param.username.isEmpty) {
        throw AppException("invalid parameter");
      }
      final result = await repository.loginUser(param);
      await manager.setLogin(result);
      return Result.success(result);
    } on Exception catch (e) {
      return Result.error(Failure(e));
    }
  }
}
