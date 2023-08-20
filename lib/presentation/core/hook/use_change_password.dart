import 'package:common/core/error/failures.dart';
import 'package:common/core/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/usecases/user/change_password.dart';

useChangePasswordLoading(
  BuildContext context, {
  required Function(bool) onSuccess,
}) {
  loading() {
    showLoadingDialog(context);
  }

  success(bool data) {
    hideLoadingDialog(context);
    onSuccess(data);
  }

  error(Failure failure) {
    hideLoadingDialog(context);
    showAlertDialog(context, failure.getMessage(), () {});
  }

  changePassword(ChangePasswordParam param) {
    final changePassword = sl<ChangePassword>();
    loading();
    final result = changePassword(param);
    result.then((value) => value.fold((l) => error(l), (r) => success(r)));
  }

  final cachedFunction = useCallback((ChangePasswordParam param) {
    changePassword(param);
  }, []);
  return cachedFunction;
}
