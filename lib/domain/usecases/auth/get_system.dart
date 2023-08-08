import 'package:common/core/error/failures.dart';
import 'package:common/core/result/result.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:um/domain/manager/session_manager.dart';
import 'package:um/domain/model/auth/system.dart';
import 'package:um/domain/repositories/login_repository.dart';

class GetSystem implements BaseUseCase<System> {
  final LoginRepository repository;
  final SessionManager manager;

  GetSystem({
    required this.repository,
    required this.manager,
  });

  @override
  FutureResult<System, Failure> call() async {
    try {
      final result = await repository.getSystem();
      await manager.setSystem(result);
      return Result.success(result);
    } on Exception catch (e) {
      return Result.error(Failure(e));
    }
  }
}
