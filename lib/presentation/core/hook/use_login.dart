import 'package:common/core/error/failures.dart';
import 'package:common/core/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/model/auth/system.dart';
import 'package:um/domain/usecases/auth/login_user.dart';

useLoginLoading(
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

  login(LoginParam param) {
    final loginUser = sl<LoginUser>();
    loading();
    final result = loginUser(param);
    result.then((value) => value.fold(onSuccess: success, onError: error));
  }

  final cachedFunction = useCallback((LoginParam param) {
    login(param);
  }, []);
  return cachedFunction;
}
