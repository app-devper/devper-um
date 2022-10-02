import 'package:common/core/error/failures.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/repositories/user_repository.dart';

class UpdateUserInfo implements UseCase<UserParam, User> {
  final UserRepository repository;

  UpdateUserInfo({required this.repository});

  @override
  Future<Either<Failure, User>> call(UserParam param) async {
    try {
      final result = await repository.updateUserInfo(param);
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure(e));
    }
  }
}
