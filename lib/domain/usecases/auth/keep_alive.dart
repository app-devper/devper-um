import 'package:common/core/error/failures.dart';
import 'package:common/core/result/result.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:um/domain/manager/session_manager.dart';
import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/repositories/login_repository.dart';

class KeepAlive implements BaseUseCase<Login> {
  final LoginRepository repository;
  final SessionManager manager;

  KeepAlive( {
    required this.repository,
    required this.manager,
  });

  @override
  FutureResult<Login, Failure> call() async {
    try {
      final accessToken = await repository.getToken();
      final result = await repository.keepAlive(accessToken);
      await manager.setLogin(result);
      return Result.success(result);
    } on Exception catch (e) {
      return Result.error(Failure(e));
    }
  }
}
