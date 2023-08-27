import 'package:common/core/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/usecases/auth/logout_user.dart';

Function() useLogout(BuildContext context, {required Function() onSuccess}) {
  loading() {
    showLoadingDialog(context);
  }

  success() {
    hideLoadingDialog(context);
    onSuccess();
  }

  final cachedFunction = useCallback(() {
    final logoutUser = sl<LogoutUser>();
    loading();
    final result = logoutUser();
    result.then((value) => {success()});
  }, []);
  return cachedFunction;
}
