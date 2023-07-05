import 'package:common/core/error/failures.dart';
import 'package:common/core/result/result.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:common/data/session/app_session_provider.dart';
import 'package:um/domain/model/auth/system.dart';
import 'package:um/domain/repositories/login_repository.dart';

class GetSystem implements BaseUseCase<System> {
  final LoginRepository repository;
  final AppSessionProvider appSession;

  GetSystem({
    required this.repository,
    required this.appSession,
  });

  @override
  FutureResult<System, Failure> call() async {
    try {
      final result = await repository.getSystem();
      appSession.setHostApp(result.host);
      appSession.setClientId(result.clientId);
      return Result.success(result);
    } on Exception catch (e) {
      return Result.error(Failure(e));
    }
  }
}
