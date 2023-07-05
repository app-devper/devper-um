import 'package:common/core/error/failures.dart';
import 'package:common/core/result/result.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:common/data/session/app_session_provider.dart';
import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/repositories/login_repository.dart';

class FetchToken implements BaseUseCase<Login> {
  final LoginRepository repository;
  final AppSessionProvider appSession;

  FetchToken({
    required this.repository,
    required this.appSession,
  });

  @override
  FutureResult<Login, Failure> call() async {
    try {
      var accessToken = await repository.getToken();
      appSession.setAccessToken(accessToken);
      var result = await repository.keepAlive();
      appSession.setAccessToken(result.accessToken);
      return Result.success(result);
    } on Exception catch (e) {
      return Result.error(Failure(e));
    }
  }
}
