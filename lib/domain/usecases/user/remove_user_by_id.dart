import 'package:common/core/error/failures.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/repositories/user_repository.dart';

class RemoveUserById implements UseCase<String, User> {
  final UserRepository repository;

  RemoveUserById({required this.repository});

  @override
  Future<Either<Failure, User>> call(String param) async {
    try {
      final result = await repository.removeUserById(param);
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure(e));
    }
  }
}
