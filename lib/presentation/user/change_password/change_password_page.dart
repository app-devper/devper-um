import 'package:common/core/utils/extension.dart';
import 'package:common/core/widget/button_widget.dart';
import 'package:common/core/widget/custom_snack_bar.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:um/core/obscure_state.dart';
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
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _oldPasswordNode = FocusNode();
  final FocusNode _newPasswordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();
  final FocusNode _viewNode = FocusNode();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late CustomSnackBar _snackBar;

  late ChangePasswordViewModel _viewModel;

  @override
  void initState() {
    super.initState();
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
    _newPasswordNode.dispose();
    _confirmPasswordNode.dispose();
    _viewNode.dispose();

    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _snackBar = CustomSnackBar(key: const Key("snackbar"), context: context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_viewNode),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: CustomTheme.mainTheme.iconTheme,
          backgroundColor: CustomColor.white,
          centerTitle: true,
          title: Text(
            "Change Password",
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
      padding: const EdgeInsets.all(defaultPagePadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            _buildPasswordField(
              context,
              _oldPasswordNode,
              _oldPasswordController,
              "Old Password*",
              _newPasswordNode,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            _buildPasswordField(
              context,
              _newPasswordNode,
              _newPasswordController,
              "New Password*",
              _confirmPasswordNode,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            _buildPasswordField(
              context,
              _confirmPasswordNode,
              _confirmPasswordController,
              "Confirm Password*",
              _viewNode,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 14),
            ),
            SizedBox(
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
      key: const Key("changePassword"),
      onClicked: () {
        if (_oldPasswordController.text.isNotEmpty && _newPasswordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty) {
          if (_newPasswordController.text == _confirmPasswordController.text) {
            _viewModel.changePassword(ChangePasswordParam(
              oldPassword: _oldPasswordController.text,
              newPassword: _newPasswordController.text,
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
      text: "Change Password",
    );
  }

  _buildPasswordField(
    BuildContext context,
    FocusNode focusNode,
    TextEditingController controller,
    String labelText,
    FocusNode nextNode,
  ) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (context) => ObscureState(),
      child: Consumer<ObscureState>(
        builder: (context, state, child) => SizedBox(
          width: size.width,
          height: 50,
          child: TextFormField(
            focusNode: focusNode,
            controller: controller,
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
              labelText: labelText,
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
              fieldFocusChange(context, focusNode, nextNode);
            },
          ),
        ),
      ),
    );
  }
}
