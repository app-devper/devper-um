import 'package:common/core/error/failures.dart';
import 'package:common/core/widget/dialog_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/model/auth/system.dart';
import 'package:um/domain/usecases/auth/get_system.dart';
import 'package:um/domain/usecases/auth/login_user.dart';
import 'package:um/presentation/core/hook/use_app_config.dart';

useLogin(BuildContext context, {required Function(bool) onSuccess, required Function(String) onError}) {

  loading() {
    showLoadingDialog(context);
  }
  success(System system) {
    final config = useAppConfig();
    hideLoadingDialog(context);
    onSuccess(system.systemCode == config.system);
  }

  error(Failure failure) {
    hideLoadingDialog(context);
    onError(failure.getMessage());
  }

  login(LoginParam param) async {
    final loginUser = sl<LoginUser>();
    final getSystem = sl<GetSystem>();
    loading();
    final login = await loginUser(param);
    if (login.isSuccess) {
      final system = await getSystem();
      if (system.isSuccess) {
        success(system.value);
      } else {
        error(system.error);
      }
    } else {
      error(login.error);
    }
  }

  final cachedFunction = useCallback((LoginParam param) {
    login(param);
  }, []);
  return cachedFunction;
}
