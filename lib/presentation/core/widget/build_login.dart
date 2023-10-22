import 'package:common/core/theme/theme.dart';
import 'package:common/core/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/domain/entities/auth/param.dart';
import 'package:um/domain/entities/auth/system.dart';
import 'package:um/hooks/use_app_config.dart';
import 'package:um/hooks/use_login.dart';
import 'package:um/presentation/core/widget/build_widget.dart';

buildLogin(bool isKeyboardOpen, Function(System) onSuccess) {
  return HookBuilder(builder: (context) {
    final usernameEditingController = useTextEditingController();
    final passwordEditingController = useTextEditingController();

    final usernameNode = useFocusNode();
    final passwordNode = useFocusNode();
    final viewNode = useFocusNode();

    final config = useAppConfig();

    getLoginParam() {
      return LoginParam(
        username: usernameEditingController.text,
        password: passwordEditingController.text,
        system: config.system,
      );
    }

    buildHeader(bool isKeyboardOpen, logo) {
      if (!isKeyboardOpen) {
        return Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 40),
            ),
            SizedBox(
              width: 120,
              height: 120,
              child: Image(
                image: AssetImage(logo),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Text(
              "Login",
              style: CustomTheme.mainTheme.textTheme.titleLarge,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 14),
            ),
          ],
        );
      }
      return const Padding(
        padding: EdgeInsets.only(top: 74),
      );
    }

    final login = useLogin(context, onSuccess: onSuccess);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        buildHeader(isKeyboardOpen, config.logo),
        buildTextFormField(
          context,
          true,
          usernameNode,
          usernameEditingController,
          "Username*",
          TextInputType.emailAddress,
          passwordNode,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        buildPasswordField(context, passwordNode, passwordEditingController, "Password*", viewNode),
        const Padding(
          padding: EdgeInsets.only(top: 14),
        ),
        ButtonWidget(
          key: const Key("login"),
          text: "LOGIN",
          onClicked: () {
            FocusScope.of(context).requestFocus(viewNode);
            login(getLoginParam());
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 14),
        ),
      ],
    );
  });
}
