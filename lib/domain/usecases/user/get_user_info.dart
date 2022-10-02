import 'package:common/core/error/failures.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/repositories/user_repository.dart';

class GetUserInfo implements UseCase<Param, User> {
  final UserRepository repository;

  GetUserInfo({required this.repository});

  @override
  Future<Either<Failure, User>> call(Param params) async {
    try {
      final result = await repository.getUserInfo();
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure(e));
    }
  }
}
