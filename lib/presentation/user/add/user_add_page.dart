import 'package:common/core/utils/extension.dart';
import 'package:common/core/widget/button_widget.dart';
import 'package:common/core/widget/custom_snack_bar.dart';
import 'package:common/data/session/app_session_provider.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/injection_container.dart';
import 'package:um/presentation/constants.dart';

import 'user_add_state.dart';
import 'user_add_view_model.dart';

class UserAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserAddPageState();
}

class _UserAddPageState extends State<UserAddPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _usernameEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final TextEditingController _firstNameEditingController = TextEditingController();
  final TextEditingController _lastNameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();

  final FocusNode _viewNode = FocusNode();
  final FocusNode _usernameNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _firstNameNode = FocusNode();
  final FocusNode _lastNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();

  late CustomSnackBar _snackBar;

  late UserAddViewModel _viewModel;
  late AppSessionProvider _appSession;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<UserAddViewModel>();
    _appSession = sl<AppSessionProvider>();
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
      } else if (state is CreateUserState) {
        hideLoadingDialog(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _snackBar.hideAll();
          _snackBar.showSnackBar(text: "Add " + state.data.username + " success");
        });
        _clearForm();
      }
    });
  }

  @override
  void dispose() {
    _usernameNode.dispose();
    _passwordNode.dispose();
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
          "Add User",
          style: CustomTheme.mainTheme.textTheme.headline5,
        ),
        brightness: Brightness.light,
      ),
      body: _buildBody(context),
    );
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
            _buildAddButton(context),
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
        _buildTextFormField(
          context,
          _usernameNode,
          _usernameEditingController,
          "Username*",
          TextInputType.text,
          _passwordNode,
        ),
        Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        _buildTextFormField(
          context,
          _passwordNode,
          _passwordEditingController,
          "Password*",
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
          "FirstName",
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
          "LastName",
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

  _buildAddButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ButtonWidget(
        key: Key("Add"),
        onClicked: () {
          FocusScope.of(context).requestFocus(_viewNode);
          _viewModel.createUser(_getCreateParam());
        },
        text: "Add",
      ),
    );
  }

  _getCreateParam() {
    return CreateParam(
      username: _usernameEditingController.text,
      password: _passwordEditingController.text,
      clientId: _appSession.getClientId(),
      firstName: _firstNameEditingController.text,
      lastName: _lastNameEditingController.text,
      phone: _phoneEditingController.text,
      email: _emailEditingController.text,
    );
  }

  _clearForm() {
    _usernameEditingController.text = "";
    _passwordEditingController.text = "";
    _firstNameEditingController.text = "";
    _lastNameEditingController.text = "";
    _phoneEditingController.text = "";
    _emailEditingController.text = "";
  }
}
