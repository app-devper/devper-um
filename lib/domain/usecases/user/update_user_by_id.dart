import 'package:common/core/error/exception.dart';
import 'package:common/core/error/failures.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/repositories/user_repository.dart';

class UpdateUserById implements UseCase<UpdateUserParam, User> {
  final UserRepository repository;

  UpdateUserById({required this.repository});

  @override
  Future<Either<Failure, User>> call(UpdateUserParam param) async {
    try {
      if (param.userParam.firstName.isEmpty || param.userParam.lastName.isEmpty) {
        throw AppException("Invalid parameter");
      }
      final result = await repository.updateUserById(param);
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure(e));
    }
  }
}
