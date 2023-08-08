import 'package:common/core/utils/extension.dart';
import 'package:common/core/widget/button_widget.dart';
import 'package:common/core/widget/custom_snack_bar.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:um/core/ext/extensions.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/container.dart';
import 'package:um/presentation/constants.dart';

import 'user_info_state.dart';
import 'user_info_view_model.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final usernameEditingController = TextEditingController();
  final firstNameEditingController = TextEditingController();
  final lastNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final phoneEditingController = TextEditingController();

  final viewNode = FocusNode();
  final usernameNode = FocusNode();
  final firstNameNode = FocusNode();
  final lastNameNode = FocusNode();
  final emailNode = FocusNode();
  final phoneNode = FocusNode();

  late CustomSnackBar _snackBar;

  late UserInfoViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<UserInfoViewModel>();
    _viewModel.states.listen((state) {
      if (state is ErrorState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _snackBar.hideAll();
          _snackBar.showErrorSnackBar(state.message);
        });
        hideLoadingDialog(context);
      } else if (state is LoadingState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _snackBar.hideAll();
        });
        showLoadingDialog(context);
      } else if (state is UpdateUserState) {
        hideLoadingDialog(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _snackBar.hideAll();
          _snackBar.showSnackBar(text: "Update ${state.data.username} success");
        });
      } else if (state is GetUserState) {
        _setupUser(state.data);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.getUserInfo();
    });
  }

  @override
  void dispose() {
    usernameNode.dispose();
    firstNameNode.dispose();
    lastNameNode.dispose();
    phoneNode.dispose();
    emailNode.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _snackBar = CustomSnackBar(key: const Key("snackbar"), context: context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: CustomTheme.mainTheme.iconTheme,
        backgroundColor: CustomColor.white,
        centerTitle: true,
        title: Text(
          "User Info",
          style: CustomTheme.mainTheme.textTheme.headline5,
        ),
      ),
      body: _buildBody(context),
    );
  }

  _setupUser(User user) {
    usernameEditingController.text = user.username;
    firstNameEditingController.text = user.firstName ?? "";
    lastNameEditingController.text = user.lastName ?? "";
    phoneEditingController.text = user.phone ?? "";
    emailEditingController.text = user.email ?? "";
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPagePadding),
      child: Column(
        children: <Widget>[
          _buildForm(context),
          const Padding(
            padding: EdgeInsets.only(top: defaultPagePadding),
          ),
          _buildUpdateButton(context),
        ],
      ),
    );
  }

  _buildForm(BuildContext context) {
    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        _buildTextFormField(
          context,
          false,
          usernameNode,
          usernameEditingController,
          "Username",
          TextInputType.text,
          firstNameNode,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        _buildTextFormField(
          context,
          true,
          firstNameNode,
          firstNameEditingController,
          "FirstName*",
          TextInputType.text,
          lastNameNode,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        _buildTextFormField(
          context,
          true,
          lastNameNode,
          lastNameEditingController,
          "LastName*",
          TextInputType.text,
          phoneNode,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        _buildTextFormField(
          context,
          true,
          phoneNode,
          phoneEditingController,
          "Phone",
          TextInputType.phone,
          emailNode,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        _buildTextFormField(
          context,
          true,
          emailNode,
          emailEditingController,
          "Email",
          TextInputType.emailAddress,
          viewNode,
        ),
      ],
    );
  }

  _buildTextFormField(
    BuildContext context,
    bool enabled,
    FocusNode focusNode,
    TextEditingController controller,
    String labelText,
    TextInputType textInputType,
    FocusNode nextNode,
  ) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 50,
      child: TextFormField(
        enabled: enabled,
        focusNode: focusNode,
        controller: controller,
        keyboardType: textInputType,
        decoration: buildInputDecoration(labelText),
        cursorColor: CustomColor.hintColor,
        onFieldSubmitted: (term) {
          fieldFocusChange(context, focusNode, nextNode);
        },
      ),
    );
  }

  _buildUpdateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ButtonWidget(
        key: const Key("update"),
        onClicked: () {
          FocusScope.of(context).requestFocus(viewNode);
          _viewModel.updateUserInfo(_getUserParam());
        },
        text: "Update",
      ),
    );
  }

  _getUserParam() {
    return UserParam(
      firstName: firstNameEditingController.text,
      lastName: lastNameEditingController.text,
      phone: phoneEditingController.text,
      email: emailEditingController.text,
    );
  }
}
