import 'package:common/core/error/failures.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:common/data/session/app_session_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/repositories/login_repository.dart';

class FetchToken implements UseCase<TokenParams, Login> {
  final LoginRepository repository;
  final AppSessionProvider appSession;

  FetchToken({
    required this.repository,
    required this.appSession,
  });

  @override
  Future<Either<Failure, Login>> call(TokenParams params) async {
    try {
      var accessToken = await repository.getToken();
      appSession.setAccessToken(accessToken);
      var result = await repository.keepAlive();
      appSession.setAccessToken(result.accessToken);
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure(e));
    }
  }
}
