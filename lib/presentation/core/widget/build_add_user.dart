import 'package:common/core/widget/button_widget.dart';
import 'package:common/core/widget/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/core/hook/use_add_user.dart';
import 'package:um/presentation/core/widget/build_widget.dart';

buildAddUser(String clientId,Function(User) onAdded) {
  return HookBuilder(builder: (context) {
    final usernameEditingController = useTextEditingController();
    final passwordEditingController = useTextEditingController();
    final firstNameEditingController = useTextEditingController();
    final lastNameEditingController = useTextEditingController();
    final emailEditingController = useTextEditingController();
    final phoneEditingController = useTextEditingController();

    final viewNode = useFocusNode();
    final usernameNode = useFocusNode();
    final passwordNode = useFocusNode();
    final firstNameNode = useFocusNode();
    final lastNameNode = useFocusNode();
    final emailNode = useFocusNode();
    final phoneNode = useFocusNode();

    final snackBar = CustomSnackBar(key: const Key("snackbar"), context: context);

    clear() {
      usernameEditingController.text = "";
      passwordEditingController.text = "";
      firstNameEditingController.text = "";
      lastNameEditingController.text = "";
      phoneEditingController.text = "";
      emailEditingController.text = "";
    }

    success(User user) {
      snackBar.hideAll();
      snackBar.showSnackBar(text: "Add ${user.username} success");
      clear();
      onAdded(user);
    }

    final add = useAddUser(context, onSuccess: success);

    getCreateParam() {
      return CreateParam(
        username: usernameEditingController.text,
        password: passwordEditingController.text,
        clientId: clientId,
        firstName: firstNameEditingController.text,
        lastName: lastNameEditingController.text,
        phone: phoneEditingController.text,
        email: emailEditingController.text,
      );
    }

    buildAddButton() {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ButtonWidget(
          key: const Key("add"),
          onClicked: () {
            FocusScope.of(context).requestFocus(viewNode);
            add(getCreateParam());
          },
          text: "Add",
        ),
      );
    }

    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        buildTextFormField(
          context,
          true,
          usernameNode,
          usernameEditingController,
          "Username*",
          TextInputType.text,
          passwordNode,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        buildTextFormField(
          context,
          true,
          passwordNode,
          passwordEditingController,
          "Password*",
          TextInputType.text,
          firstNameNode,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        buildTextFormField(
          context,
          true,
          firstNameNode,
          firstNameEditingController,
          "FirstName",
          TextInputType.text,
          lastNameNode,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        buildTextFormField(
          context,
          true,
          lastNameNode,
          lastNameEditingController,
          "LastName",
          TextInputType.text,
          phoneNode,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        buildTextFormField(
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
        buildTextFormField(
          context,
          true,
          emailNode,
          emailEditingController,
          "Email",
          TextInputType.emailAddress,
          viewNode,
        ),
        const Padding(
          padding: EdgeInsets.only(top: defaultPagePadding),
        ),
        buildAddButton(),
      ],
    );
  });
}
