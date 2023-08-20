import 'package:common/core/error/failures.dart';
import 'package:common/core/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/usecases/user/remove_user_by_id.dart';

useRemoveUserLoading(
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

  removeUserById(String param) {
    final removeUserById = sl<RemoveUserById>();
    loading();
    final result = removeUserById(param);
    result.then((value) => value.fold((l) => error(l), (r) => success(r)));
  }

  final cachedFunction = useCallback((String param) {
    removeUserById(param);
  }, []);
  return cachedFunction;
}
