import 'package:common/core/error/exception.dart';
import 'package:common/core/error/failures.dart';
import 'package:common/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/repositories/user_repository.dart';

class ChangePassword extends UseCase<ChangePasswordParam, bool> {
  final UserRepository repository;

  ChangePassword({required this.repository});

  @override
  Future<Either<Failure, bool>> call(ChangePasswordParam param) async {
    try {
      if (param.oldPassword.isEmpty || param.newPassword.isEmpty) {
        throw AppException("Invalid parameter");
      }
      final result = await repository.changePassword(param);
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure(e));
    }
  }
}
