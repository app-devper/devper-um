import 'package:common/core/error/failure.dart';
import 'package:common/core/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/entities/user/param.dart';
import 'package:um/domain/entities/user/user.dart';
import 'package:um/domain/repositories/user_repository.dart';

Function(UserParam) useUpdateUserInfo(
  BuildContext context, {
  required Function(User) onSuccess,
}) {
  loading() {
    showLoadingDialog(context);
  }

  success(User user) {
    hideLoadingDialog(context);
    onSuccess(user);
  }

  error(Failure failure) {
    hideLoadingDialog(context);
    showAlertDialog(context, failure.getMessage(), () {});
  }

  updateUserInfo(UserParam param) async {
    final userRepo = sl<UserRepository>();
    loading();
    try {
      final result = await userRepo.updateUserInfo(param);
      success(result);
    } on Exception catch (e) {
      error(toFailure(e));
    }
  }

  final cachedFunction = useCallback((UserParam param) {
    updateUserInfo(param);
  }, []);
  return cachedFunction;
}
