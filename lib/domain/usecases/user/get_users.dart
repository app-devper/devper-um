import 'package:common/core/error/failures.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/repositories/user_repository.dart';

class GetUsers implements UseCase<Param, List<User>> {
  final UserRepository repository;

  GetUsers({required this.repository});

  @override
  Future<Either<Failure, List<User>>> call(Param param) async {
    try {
      final result = await repository.getUsers();
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure(e));
    }
  }
}
