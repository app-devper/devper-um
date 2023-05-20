import 'package:common/core/utils/extension.dart';
import 'package:common/core/widget/button_widget.dart';
import 'package:common/core/widget/custom_snack_bar.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/container.dart';
import 'package:um/presentation/constants.dart';

import 'package:um/presentation/user/change_password/change_password_state.dart';
import 'package:um/presentation/user/change_password/change_password_view_model.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  final FocusNode _oldPasswordNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _passwordConfirmNode = FocusNode();
  final FocusNode _viewNode = FocusNode();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late CustomSnackBar _snackBar;
  late BooleanPrimitiveWrapper _obscureOldPasswordText;
  late BooleanPrimitiveWrapper _obscurePasswordText;
  late BooleanPrimitiveWrapper _obscurePasswordConfirmText;

  late ChangePasswordViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _obscureOldPasswordText = BooleanPrimitiveWrapper(true);
    _obscurePasswordText = BooleanPrimitiveWrapper(true);
    _obscurePasswordConfirmText = BooleanPrimitiveWrapper(true);

    _viewModel = sl<ChangePasswordViewModel>();
    _viewModel.states.stream.listen((state) {
      if (state is LoadingState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _snackBar.hideAll();
        });
        showLoadingDialog(context);
      } else if (state is UpdatePasswordState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _snackBar.hideAll();
        });
        hideLoadingDialog(context);
        Navigator.pop(context);
      } else if (state is ErrorState) {
        hideLoadingDialog(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _snackBar.hideAll();
          _snackBar.showErrorSnackBar(state.message);
        });
      }
    });
  }

  @override
  void dispose() {
    _oldPasswordNode.dispose();
    _passwordNode.dispose();
    _passwordConfirmNode.dispose();
    _viewNode.dispose();

    _oldPasswordController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();

    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _snackBar = CustomSnackBar(key: Key("snackbar"), context: context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_viewNode),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: CustomTheme.mainTheme.iconTheme,
          backgroundColor: CustomColor.white,
          centerTitle: true,
          title: Text(
            "ChangePassword",
            style: CustomTheme.mainTheme.textTheme.headline5,
          ),
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: CustomColor.statusBarColor,
          ),
          child: _buildBody(context),
        ),
      ),
    );
  }

  _buildBody(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.all(DEFAULT_PAGE_PADDING),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            _buildPasswordField(
              context,
              _oldPasswordNode,
              _oldPasswordController,
              _obscureOldPasswordText,
              "Old Password*",
              _passwordNode,
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            _buildPasswordField(
              context,
              _passwordNode,
              _passwordController,
              _obscurePasswordText,
              "New Password*",
              _passwordConfirmNode,
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            _buildPasswordField(
              context,
              _passwordConfirmNode,
              _passwordConfirmController,
              _obscurePasswordConfirmText,
              "Confirm Password*",
              _viewNode,
            ),
            Padding(
              padding: EdgeInsets.only(top: 14),
            ),
            Container(
              width: double.infinity,
              height: 50,
              child: _buildChangePasswordButton(),
            ),
          ],
        ),
      ),
    );
  }

  _buildChangePasswordButton() {
    return ButtonWidget(
      key: Key("changePassword"),
      onClicked: () {
        if (_oldPasswordController.text.isNotEmpty && _passwordController.text.isNotEmpty && _passwordConfirmController.text.isNotEmpty) {
          if (_passwordController.text == _passwordConfirmController.text) {
            _viewModel.changePassword(ChangePasswordParam(
              oldPassword: _oldPasswordController.text,
              newPassword: _passwordController.text,
            ));
          } else {
            _snackBar.hideAll();
            _snackBar.showErrorSnackBar("Passwords do not match");
          }
        } else {
          _snackBar.hideAll();
          _snackBar.showErrorSnackBar("Fields can't be empty");
        }
      },
      text: "CHANGE PASSWORD",
    );
  }

  _buildPasswordField(
    BuildContext context,
    FocusNode focusNode,
    TextEditingController controller,
    BooleanPrimitiveWrapper obscureText,
    String labelText,
    FocusNode nextNode,
  ) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 50,
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        obscureText: obscureText.value,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          focusedBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(4.0),
            borderSide: new BorderSide(
              color: CustomColor.textFieldBackground,
            ),
          ),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(4.0),
            borderSide: new BorderSide(
              color: CustomColor.textFieldBackground,
            ),
          ),
          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(4.0),
            borderSide: new BorderSide(
              color: CustomColor.textFieldBackground,
            ),
          ),
          focusColor: CustomColor.hintColor,
          hoverColor: CustomColor.hintColor,
          fillColor: CustomColor.textFieldBackground,
          filled: true,
          labelText: labelText,
          labelStyle: CustomTheme.mainTheme.textTheme.bodyText2,
          suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye),
            color: CustomColor.hintColor,
            onPressed: () {
              setState(() {
                obscureText.value = !obscureText.value;
              });
            },
          ),
        ),
        cursorColor: CustomColor.hintColor,
        onFieldSubmitted: (term) {
          fieldFocusChange(context, focusNode, nextNode);
        },
      ),
    );
  }
}

class BooleanPrimitiveWrapper {
  bool value;

  BooleanPrimitiveWrapper(this.value);
}
