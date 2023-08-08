import 'package:common/core/utils/extension.dart';
import 'package:common/core/widget/button_widget.dart';
import 'package:common/core/widget/custom_snack_bar.dart';
import 'package:common/data/session/app_session_provider.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/container.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/user/add/user_add_state.dart';
import 'package:um/presentation/user/add/user_add_view_model.dart';

class UserAddPage extends StatefulWidget {
  const UserAddPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserAddPageState();
}

class _UserAddPageState extends State<UserAddPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final usernameEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final firstNameEditingController = TextEditingController();
  final lastNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final phoneEditingController = TextEditingController();

  final viewNode = FocusNode();
  final usernameNode = FocusNode();
  final passwordNode = FocusNode();
  final firstNameNode = FocusNode();
  final lastNameNode = FocusNode();
  final emailNode = FocusNode();
  final phoneNode = FocusNode();

  late CustomSnackBar _snackBar;

  late UserAddViewModel _viewModel;
  late AppSessionProvider _appSession;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<UserAddViewModel>();
    _appSession = sl<AppSessionProvider>();
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
      } else if (state is CreateUserState) {
        hideLoadingDialog(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _snackBar.hideAll();
          _snackBar.showSnackBar(text: "Add ${state.data.username} success");
        });

        _clearForm();
      }
    });
  }

  @override
  void dispose() {
    usernameNode.dispose();
    passwordNode.dispose();
    firstNameNode.dispose();
    lastNameNode.dispose();
    phoneNode.dispose();
    emailNode.dispose();
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
          "Add User",
          style: CustomTheme.mainTheme.textTheme.headline5,
        ),
      ),
      body: _buildBody(context),
    );
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
          usernameNode,
          usernameEditingController,
          "Username*",
          TextInputType.text,
          passwordNode,
        ),
        Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        _buildTextFormField(
          context,
          passwordNode,
          passwordEditingController,
          "Password*",
          TextInputType.text,
          firstNameNode,
        ),
        Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        _buildTextFormField(
          context,
          firstNameNode,
          firstNameEditingController,
          "FirstName",
          TextInputType.text,
          lastNameNode,
        ),
        Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        _buildTextFormField(
          context,
          lastNameNode,
          lastNameEditingController,
          "LastName",
          TextInputType.text,
          phoneNode,
        ),
        Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        _buildTextFormField(
          context,
          phoneNode,
          phoneEditingController,
          "Phone",
          TextInputType.phone,
          emailNode,
        ),
        Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        _buildTextFormField(
          context,
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
        focusNode: focusNode,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
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
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ButtonWidget(
        key: const Key("Add"),
        onClicked: () {
          FocusScope.of(context).requestFocus(viewNode);
          _viewModel.createUser(_getCreateParam());
        },
        text: "Add",
      ),
    );
  }

  _getCreateParam() {
    return CreateParam(
      username: usernameEditingController.text,
      password: passwordEditingController.text,
      clientId: _appSession.getClientId(),
      firstName: firstNameEditingController.text,
      lastName: lastNameEditingController.text,
      phone: phoneEditingController.text,
      email: emailEditingController.text,
    );
  }

  _clearForm() {
    usernameEditingController.text = "";
    passwordEditingController.text = "";
    firstNameEditingController.text = "";
    lastNameEditingController.text = "";
    phoneEditingController.text = "";
    emailEditingController.text = "";
  }
}
