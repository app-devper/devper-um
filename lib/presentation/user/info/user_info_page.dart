import 'package:common/core/utils/extension.dart';
import 'package:common/core/widget/button_widget.dart';
import 'package:common/core/widget/custom_snack_bar.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/container.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/user/info/user_info_state.dart';
import 'package:um/presentation/user/info/user_info_view_model.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
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

  late UserInfoViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<UserInfoViewModel>();
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

  void _setupUser(User user) {
    _usernameEditingController.text = user.username;
    _firstNameEditingController.text = user.firstName ?? "";
    _lastNameEditingController.text = user.lastName ?? "";
    _phoneEditingController.text = user.phone ?? "";
    _emailEditingController.text = user.email ?? "";
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(defaultPagePadding),
      child: Container(
        child: Column(
          children: <Widget>[
            _buildForm(context),
            Padding(
              padding: EdgeInsets.only(top: defaultPagePadding),
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

  _buildUpdateButton(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ButtonWidget(
        key: Key("Update"),
        onClicked: () {
          FocusScope.of(context).requestFocus(_viewNode);
          _viewModel.updateUserInfo(_getUserParam());
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
