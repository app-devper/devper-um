import 'package:common/core/error/failures.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/repositories/user_repository.dart';

class CreateUser implements UseCase<CreateParam, User> {
  final UserRepository repository;

  CreateUser({required this.repository});

  @override
  Future<Either<Failure, User>> call(CreateParam param) async {
    try {
      final result = await repository.createUser(param);
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure(e));
    }
  }
}
