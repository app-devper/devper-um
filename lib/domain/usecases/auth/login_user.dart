import 'package:common/core/error/exception.dart';
import 'package:common/core/error/failures.dart';
import 'package:common/core/result/result.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:common/data/session/app_session_provider.dart';
import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/repositories/login_repository.dart';

class LoginUser implements BaseUseCaseParam<LoginParam, Login> {
  final LoginRepository repository;
  final AppSessionProvider appSession;

  LoginUser({
    required this.repository,
    required this.appSession,
  });

  @override
  FutureResult<Login, Failure> call(LoginParam param) async {
    try {
      if (param.password.isEmpty || param.username.isEmpty) {
        throw AppException("invalid parameter");
      }
      var result = await repository.loginUser(param);
      appSession.setAccessToken(result.accessToken);
      return Result.success(result);
    } on Exception catch (e) {
      return Result.error(Failure(e));
    }
  }
}
