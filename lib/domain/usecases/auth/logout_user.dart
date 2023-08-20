import 'package:common/core/error/failures.dart';
import 'package:common/core/result/result.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:common/data/session/app_session_provider.dart';
import 'package:um/domain/repositories/login_repository.dart';

class LogoutUser implements BaseUseCase<bool> {
  final LoginRepository repository;
  final AppSessionProvider appSession;

  LogoutUser({
    required this.repository,
    required this.appSession,
  });

  @override
  FutureResult<bool, Failure> call() async {
    try {
      final result = await repository.logoutUser();
      appSession.clear();
      return Result.success(result);
    } on Exception catch (e) {
      return Result.error(Failure(e));
    }
  }
}
