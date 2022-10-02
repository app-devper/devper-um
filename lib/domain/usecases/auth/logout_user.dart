import 'package:common/core/error/failures.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/repositories/login_repository.dart';

class LogOutUser implements UseCase<LogOutParams, bool> {
  final LoginRepository repository;

  LogOutUser({required this.repository});

  @override
  Future<Either<Failure, bool>> call(LogOutParams params) async {
    try {
      final result = await repository.logoutUser();
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure(e));
    }
  }
}


