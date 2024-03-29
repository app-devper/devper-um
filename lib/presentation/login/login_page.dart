import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/domain/entities/auth/system.dart';
import 'package:um/hooks/use_app_config.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/core/widget/build_login.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewNode = useFocusNode();
    final config = useAppConfig();

    nextHome(System system) {
      if (system.systemCode == config.system) {
        Navigator.pushNamedAndRemoveUntil(context, config.home, (r) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, routeError, (r) => false);
      }
    }

    buildBody() {
      final Size size = MediaQuery.of(context).size;
      final bool isKeyboardOpen = (MediaQuery.of(context).viewInsets.bottom > 0);
      return Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(defaultPagePadding),
        child: SingleChildScrollView(
          child: buildLogin(isKeyboardOpen, (system) {
            nextHome(system);
          }),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(viewNode),
      child: Scaffold(
        body: buildBody(),
      ),
    );
  }
}
