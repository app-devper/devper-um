import 'package:common/core/error/failures.dart';
import 'package:common/core/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/usecases/user/create_user.dart';

Function(CreateParam) useAddUser(
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

  call(CreateParam param) {
    final createUser = sl<CreateUser>();
    loading();
    final result = createUser(param);
    result.then((value) => value.fold((l) => error(l), (r) => success(r)));
  }

  final cachedFunction = useCallback((CreateParam param) {
    call(param);
  }, []);
  return cachedFunction;
}
