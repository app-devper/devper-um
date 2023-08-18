import 'package:common/core/widget/dialog_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/usecases/auth/logout_user.dart';

useLogout({required Function() onSuccess}) {
  final cachedFunction = useCallback(() async {
    final logoutUser = sl<LogoutUser>();
    showLoadingDialog(useContext());
    final logout = await logoutUser();
    hideLoadingDialog(useContext());
    if (logout.isSuccess) {
      onSuccess();
    } else {
      onSuccess();
    }
  }, []);
  return cachedFunction;
}
