import 'package:common/core/widget/button_widget.dart';
import 'package:common/core/widget/dialog_widget.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:um/container.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/core/obscure_state.dart';
import 'package:um/core/stacked_view.dart';

import 'login_state.dart';
import 'login_view_model.dart';

class LoginPage extends StackedView<LoginViewModel> {
  const LoginPage({super.key});

  @override
  void onViewModelReady(LoginViewModel viewModel) {
    viewModel.fetchToken();
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) {
    final viewModel = sl<LoginViewModel>();
    viewModel.states.listen((state) {
      if (state is LoadingState) {
        showLoadingDialog(context);
      } else if (state is LoggedState) {
        hideLoadingDialog(context);
        Navigator.pushNamedAndRemoveUntil(context, routeLanding, (r) => false);
      } else if (state is ErrorState) {
        hideLoadingDialog(context);
        showAlertDialog(context, message: state.message, onConfirm: () {});
      }
    });
    return viewModel;
  }

  @override
  onDispose() {}

  @override
  Widget builder(BuildContext context, LoginViewModel viewModel) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(viewModel.viewNode),
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
    return StreamBuilder(
      initialData: true,
      stream: viewModel.initLoading,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data ?? true) {
          return Center(
            child: CircularProgressIndicator(
              color: CustomColor.backgroundMain,
            ),
          );
        } else {
          return _buildLogin(context, viewModel);
        }
      },
    );
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
      text: "LOGIN",
      onClicked: () {
        viewModel.login();
      },
    );
  }

  _buildUsernameField(BuildContext context, LoginViewModel viewModel) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 50,
      child: TextFormField(
        focusNode: viewModel.usernameNode,
        controller: viewModel.usernameEditingController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
              color: CustomColor.textFieldBackground,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
              color: CustomColor.textFieldBackground,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
              color: CustomColor.textFieldBackground,
            ),
          ),
          focusColor: CustomColor.hintColor,
          hoverColor: CustomColor.textFieldBackground,
          fillColor: CustomColor.textFieldBackground,
          filled: true,
          labelText: "Username*",
          labelStyle: CustomTheme.mainTheme.textTheme.bodyText2,
        ),
        cursorColor: CustomColor.hintColor,
        onFieldSubmitted: (term) {
          fieldFocusChange(context, viewModel.usernameNode, viewModel.passwordNode);
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
            focusNode: viewModel.passwordNode,
            controller: viewModel.passwordEditingController,
            obscureText: state.isTrue,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(
                  color: CustomColor.textFieldBackground,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(
                  color: CustomColor.textFieldBackground,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(
                  color: CustomColor.textFieldBackground,
                ),
              ),
              focusColor: CustomColor.hintColor,
              hoverColor: CustomColor.textFieldBackground,
              fillColor: CustomColor.textFieldBackground,
              filled: true,
              labelText: "Password*",
              labelStyle: CustomTheme.mainTheme.textTheme.bodyText2,
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
              fieldFocusChange(context, viewModel.passwordNode, viewModel.viewNode);
            },
          ),
        ),
      ),
    );
  }

  fieldFocusChange(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
