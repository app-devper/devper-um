
import 'package:common/core/utils/extension.dart';
import 'package:common/core/widget/button_widget.dart';
import 'package:common/core/widget/custom_snack_bar.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/injection_container.dart';
import 'package:um/presentation/constants.dart';

import 'user_edit_state.dart';
import 'user_edit_view_model.dart';

class UserEditPage extends StatefulWidget {
  final User user;

  UserEditPage({required this.user});

  @override
  State<StatefulWidget> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _usernameEditingController = TextEditingController();
  final TextEditingController _firstNameEditingController = TextEditingController();
  final TextEditingController _lastNameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();

  final FocusNode _viewNode = FocusNode();
  final FocusNode _usernameNode = FocusNode();
  final FocusNode _firstNameNode = FocusNode();
  final FocusNode _lastNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  late CustomSnackBar _snackBar;

  late UserEditViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<UserEditViewModel>();
    _viewModel.states.stream.listen((state) {
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
          _snackBar.showSnackBar(text: "Update " + state.data.username + " success");
        });
      } else if (state is RemoveUserState) {
        hideLoadingDialog(context);
        Navigator.pop(context, state.data);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupUser(widget.user);
      _viewModel.getUserById(widget.user.id);
    });
  }

  @override
  void dispose() {
    _usernameNode.dispose();
    _firstNameNode.dispose();
    _lastNameNode.dispose();
    _phoneNode.dispose();
    _emailNode.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _snackBar = CustomSnackBar(key: Key("snackbar"), context: context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: CustomTheme.mainTheme.iconTheme,
        textTheme: CustomTheme.mainTheme.textTheme,
        backgroundColor: CustomColor.white,
        centerTitle: true,
        title: Text(
          "Edit User",
          style: CustomTheme.mainTheme.textTheme.headline5,
        ),
        actions: _buildAction(context),
        brightness: Brightness.light,
      ),
      body: _buildBody(context),
    );
  }

  void _setupUser(User user) {
    _usernameEditingController.text = user.username;
    _firstNameEditingController.text = user.firstName ?? "";
    _lastNameEditingController.text = user.lastName ?? "";
    _phoneEditingController.text = user.phone ?? "";
    _emailEditingController.text = user.email ?? "";
  }

  List<Widget> _buildAction(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          _showRemoveUserConfirm(context, widget.user);
        },
        icon: Icon(Icons.delete),
      ),
    ];
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(DEFAULT_PAGE_PADDING),
      child: Container(
        child: Column(
          children: <Widget>[
            _buildForm(context),
            Padding(
              padding: EdgeInsets.only(top: DEFAULT_PAGE_PADDING),
            ),
            _buildUpdateButton(context),
          ],
        ),
      ),
    );
  }

  _buildForm(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        _buildUsernameField(
          context,
          _usernameNode,
          _usernameEditingController,
          "Username",
          TextInputType.text,
          _firstNameNode,
        ),
        Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        _buildTextFormField(
          context,
          _firstNameNode,
          _firstNameEditingController,
          "FirstName*",
          TextInputType.text,
          _lastNameNode,
        ),
        Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        _buildTextFormField(
          context,
          _lastNameNode,
          _lastNameEditingController,
          "LastName*",
          TextInputType.text,
          _phoneNode,
        ),
        Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        _buildTextFormField(
          context,
          _phoneNode,
          _phoneEditingController,
          "Phone",
          TextInputType.phone,
          _emailNode,
        ),
        Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        _buildTextFormField(
          context,
          _emailNode,
          _emailEditingController,
          "Email",
          TextInputType.emailAddress,
          _viewNode,
        ),
      ],
    );
  }

  _buildTextFormField(
    BuildContext context,
    FocusNode focusNode,
    TextEditingController controller,
    String labelText,
    TextInputType textInputType,
    FocusNode nextNode,
  ) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 50,
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: textInputType,
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
          hoverColor: CustomColor.textFieldBackground,
          fillColor: CustomColor.textFieldBackground,
          filled: true,
          labelText: labelText,
          labelStyle: CustomTheme.mainTheme.textTheme.bodyText2,
        ),
        cursorColor: CustomColor.hintColor,
        onFieldSubmitted: (term) {
          fieldFocusChange(context, focusNode, nextNode);
        },
      ),
    );
  }

  _buildUsernameField(
    BuildContext context,
    FocusNode focusNode,
    TextEditingController controller,
    String labelText,
    TextInputType textInputType,
    FocusNode nextNode,
  ) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 50,
      child: TextFormField(
        enabled: false,
        focusNode: focusNode,
        controller: controller,
        keyboardType: textInputType,
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
          hoverColor: CustomColor.textFieldBackground,
          fillColor: CustomColor.textFieldBackground,
          filled: true,
          labelText: labelText,
          labelStyle: CustomTheme.mainTheme.textTheme.bodyText2,
        ),
        cursorColor: CustomColor.hintColor,
        onFieldSubmitted: (term) {
          fieldFocusChange(context, focusNode, nextNode);
        },
      ),
    );
  }

  _showRemoveUserConfirm(BuildContext context, User user) {
    showConfirmDialog(context, "แจ้งเตือน", "ต้องการลบผู้ใช้งาน " + user.username + " ใช่หรือไม่?", () {
      _viewModel.removeUserById(user.id);
    });
  }

  _buildUpdateButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ButtonWidget(
        key: Key("Update"),
        onClicked: () {
          FocusScope.of(context).requestFocus(_viewNode);
          _viewModel.updateUserById(UpdateUserParam(
            userId: widget.user.id,
            userParam: _getUserParam(),
          ));
        },
        text: "Update",
      ),
    );
  }

  _getUserParam() {
    return UserParam(
      firstName: _firstNameEditingController.text,
      lastName: _lastNameEditingController.text,
      phone: _phoneEditingController.text,
      email: _emailEditingController.text,
    );
  }
}
