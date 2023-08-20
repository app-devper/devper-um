import 'package:common/core/error/exception.dart';
import 'package:common/core/error/failures.dart';
import 'package:common/core/result/result.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:common/data/session/app_session_provider.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/model/auth/system.dart';
import 'package:um/domain/repositories/login_repository.dart';

class LoginUser implements BaseUseCaseParam<LoginParam, System> {
  final LoginRepository repository;
  final AppSessionProvider appSession;

  LoginUser({
    required this.repository,
    required this.appSession,
  });

  @override
  FutureResult<System, Failure> call(LoginParam param) async {
    try {
      if (param.password.isEmpty || param.username.isEmpty) {
        throw AppException("invalid parameter");
      }
      final result = await repository.loginUser(param);
      appSession.setAccessToken(result.accessToken);
      final system = await repository.getSystem();
      appSession.setClientId(system.clientId);
      appSession.setHostApp(system.host);
      return Result.success(system);
    } on Exception catch (e) {
      return Result.error(Failure(e));
    }
  }
}
