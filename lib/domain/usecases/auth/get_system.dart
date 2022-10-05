import 'package:common/core/error/failures.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:common/data/session/app_session_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:um/domain/model/system/system.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/repositories/login_repository.dart';

class GetSystem implements UseCase<Param, System> {
  final LoginRepository repository;
  final AppSessionProvider appSession;

  GetSystem({
    required this.repository,
    required this.appSession,
  });

  @override
  Future<Either<Failure, System>> call(Param params) async {
    try {
      final result = await repository.getSystem();
      appSession.setHostApp(result.host);
      appSession.setClientId(result.clientId);
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure(e));
    }
  }
}
