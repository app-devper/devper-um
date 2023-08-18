import 'package:common/core/widget/button_widget.dart';
import 'package:common/core/widget/dialog_widget.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:um/core/ext/extensions.dart';
import 'package:um/core/widget/obscure_state.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/login/hook/use_keep_alive.dart';
import 'package:um/presentation/login/hook/use_login.dart';
import 'package:um/presentation/core/hook/use_app_config.dart';

import 'login_view_mixin.dart';

class LoginPage extends HookWidget with LoginViewMixin {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      return () {
        disposeView();
      };
    }, []);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(viewNode),
      child: Scaffold(
        body: _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    final config = useAppConfig();

    nextHome(next) {
      if (next) {
        Navigator.pushNamedAndRemoveUntil(context, config.home, (r) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, routeError, (r) => false);
      }
    }

    final login = useLogin(context, onSuccess: (next) {
      nextHome(next);
    }, onError: (message) {
      showAlertDialog(context, message: message, onConfirm: () {});
    });

    final keepAlive = useKeepAlive(onSuccess: (next) {
      nextHome(next);
    });

    return keepAlive.toWidgetLoading(widgetBuilder: (_) => _buildLogin(context, login));
  }

  _buildLogin(BuildContext context, Function login) {
    final Size size = MediaQuery.of(context).size;
    final bool isKeyboardOpen = (MediaQuery.of(context).viewInsets.bottom > 0);
    return Container(
      height: size.height,
      width: size.width,
      padding: const EdgeInsets.all(defaultPagePadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildHeader(isKeyboardOpen),
            _buildUsernameField(context),
            const Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            _buildPasswordField(context),
            const Padding(
              padding: EdgeInsets.only(top: 14),
            ),
            _buildLoginButton(login),
            const Padding(
              padding: EdgeInsets.only(top: 14),
            ),
          ],
        ),
      ),
    );
  }

  _buildHeader(bool isKeyboardOpen) {
    final config = useAppConfig();
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
              image: AssetImage(config.logo),
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

  _buildLoginButton(Function login) {
    final config = useAppConfig();
    return ButtonWidget(
      key: const Key("login"),
      text: "LOGIN",
      onClicked: () {
        login(_getLoginParam(config.system));
      },
    );
  }

  _buildUsernameField(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 50,
      child: TextFormField(
        focusNode: usernameNode,
        controller: usernameEditingController,
        keyboardType: TextInputType.emailAddress,
        decoration: buildInputDecoration("Username*"),
        cursorColor: CustomColor.hintColor,
        onFieldSubmitted: (term) {
          _fieldFocusChange(context, usernameNode, passwordNode);
        },
      ),
    );
  }

  _buildPasswordField(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (context) => ObscureState(),
      child: Consumer<ObscureState>(
        builder: (context, state, child) => SizedBox(
          width: size.width,
          height: 50,
          child: TextFormField(
            focusNode: passwordNode,
            controller: passwordEditingController,
            obscureText: state.isTrue,
            keyboardType: TextInputType.visiblePassword,
            decoration: buildInputDecoration(
              "Password*",
              suffixIcon: IconButton(
                icon: state.switchObsIcon,
                color: CustomColor.hintColor,
                onPressed: () {
                  state.toggleObs();
                },
              ),
            ),
            cursorColor: CustomColor.hintColor,
            onFieldSubmitted: (term) {
              _fieldFocusChange(context, passwordNode, viewNode);
            },
          ),
        ),
      ),
    );
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  _getLoginParam(String system) {
    return LoginParam(
      username: usernameEditingController.text,
      password: passwordEditingController.text,
      system: system,
    );
  }
}
