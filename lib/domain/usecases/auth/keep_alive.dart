import 'package:common/core/error/failures.dart';
import 'package:common/core/result/result.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:common/data/session/app_session_provider.dart';
import 'package:um/domain/model/auth/system.dart';
import 'package:um/domain/repositories/login_repository.dart';

class KeepAlive implements BaseUseCase<System> {
  final LoginRepository repository;
  final AppSessionProvider appSession;

  KeepAlive({
    required this.repository,
    required this.appSession,
  });

  @override
  FutureResult<System, Failure> call() async {
    try {
      final accessToken = await repository.getToken();
      final result = await repository.keepAlive(accessToken);
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
