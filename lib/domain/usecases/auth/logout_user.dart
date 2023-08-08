import 'package:common/core/error/failures.dart';
import 'package:common/core/result/result.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:um/domain/manager/session_manager.dart';
import 'package:um/domain/repositories/login_repository.dart';

class LogoutUser implements BaseUseCase<bool> {
  final LoginRepository repository;
  final SessionManager manager;

  LogoutUser({
    required this.repository,
    required this.manager,
  });

  @override
  FutureResult<bool, Failure> call() async {
    try {
      final result = await repository.logoutUser();
      await manager.clearAppSession();
      return Result.success(result);
    } on Exception catch (e) {
      return Result.error(Failure(e));
    }
  }
}
