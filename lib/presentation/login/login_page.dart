import 'package:common/app_config.dart';
import 'package:common/core/widget/button_widget.dart';
import 'package:common/core/widget/dialog_widget.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:um/container.dart';
import 'package:um/core/ext/extensions.dart';
import 'package:um/core/widget/obscure_state.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/core/view_model/stacked_view.dart';

import 'login_state.dart';
import 'login_view_mixin.dart';
import 'login_view_model.dart';

class LoginPage extends StackedView<LoginViewModel> with LoginViewMixin {

  LoginPage({super.key});

  @override
  void onViewModelReady(LoginViewModel viewModel) {
    viewModel.keepAlive();
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) {
    final viewModel = sl<LoginViewModel>();
    viewModel.states.listen((state) {
      if (state is LoadingState) {
        showLoadingDialog(context);
      } else if (state is LoggedState) {
        viewModel.getSystem();
      } else if (state is SystemState) {
        hideLoadingDialog(context);
        if (state.data.systemCode == viewModel.config.system) {
          Navigator.pushNamedAndRemoveUntil(context, viewModel.config.home, (r) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, routeError, (r) => false);
        }
      } else if (state is ErrorState) {
        hideLoadingDialog(context);
        showAlertDialog(context, message: state.message, onConfirm: () {});
      }
    });
    return viewModel;
  }

  @override
  onDispose() {
    disposeView();
  }

  @override
  Widget builder(BuildContext context, LoginViewModel viewModel) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(viewNode),
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: CustomColor.statusBarColor,
          ),
          child: _buildBody(context, viewModel),
        ),
      ),
    );
  }

  _buildBody(BuildContext context, LoginViewModel viewModel) {
    return viewModel.init.toWidgetLoading(widgetBuilder: (_) => _buildLogin(context, viewModel));
  }

  _buildLogin(BuildContext context, LoginViewModel viewModel) {
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
            _buildHeader(isKeyboardOpen, viewModel),
            _buildUsernameField(context, viewModel),
            const Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            _buildPasswordField(context, viewModel),
            const Padding(
              padding: EdgeInsets.only(top: 14),
            ),
            _buildLoginButton(viewModel),
            const Padding(
              padding: EdgeInsets.only(top: 14),
            ),
          ],
        ),
      ),
    );
  }

  _buildHeader(bool isKeyboardOpen, LoginViewModel viewModel) {
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
              image: AssetImage(viewModel.config.logo),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Text(
            "Login",
            style: CustomTheme.mainTheme.textTheme.headline6,
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

  _buildLoginButton(LoginViewModel viewModel) {
    return ButtonWidget(
      key: const Key("login"),
      text: "LOGIN",
      onClicked: () {
        viewModel.login(_getLoginParam(viewModel));
      },
    );
  }

  _buildUsernameField(BuildContext context, LoginViewModel viewModel) {
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

  _buildPasswordField(BuildContext context, LoginViewModel viewModel) {
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

  _getLoginParam(LoginViewModel viewModel) {
    return LoginParam(
      username: usernameEditingController.text,
      password: passwordEditingController.text,
      system: viewModel.config.system,
    );
  }
}
