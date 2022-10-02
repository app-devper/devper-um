import 'package:common/core/error/failures.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/repositories/login_repository.dart';

class GetLogin implements UseCase<GetLoginParam, bool> {
  final LoginRepository repository;

  GetLogin({required this.repository});

  @override
  Future<Either<Failure, bool>> call(GetLoginParam param) async {
    try {
      var result = await repository.getRole();
      return Right(result == "ADMIN");
    } on Exception catch (e) {
      return Left(Failure(e));
    }
  }
}
