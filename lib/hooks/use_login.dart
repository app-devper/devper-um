import 'package:common/core/error/failure.dart';
import 'package:common/core/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/entities/auth/param.dart';
import 'package:um/domain/entities/auth/system.dart';
import 'package:um/domain/repositories/login_repository.dart';

Function(LoginParam) useLogin(
  BuildContext context, {
  required Function(System) onSuccess,
}) {
  loading() {
    showLoadingDialog(context);
  }

  success(System system) {
    hideLoadingDialog(context);
    onSuccess(system);
  }

  error(Failure failure) {
    hideLoadingDialog(context);
    showAlertDialog(context, failure.getMessage(), () {});
  }

  loginUser(LoginParam param) async {
    final loginRepo = sl<LoginRepository>();
    loading();
    try {
      final _ = await loginRepo.loginUser(param);
      final result = await loginRepo.getSystem();
      success(result);
    } on Exception catch (e) {
      error(toFailure(e));
    }
  }

  final cachedFunction = useCallback(loginUser, []);
  return cachedFunction;
}
