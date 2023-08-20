import 'package:common/core/widget/button_widget.dart';
import 'package:common/core/widget/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/core/hook/use_update_user.dart';
import 'package:um/presentation/core/widget/build_widget.dart';

buildUser(User user, Function(User) onSuccess) {
  return HookBuilder(builder: (context) {
    final snackBar = CustomSnackBar(key: const Key("snackbar"), context: context);

    final usernameEditingController = useTextEditingController();
    final firstNameEditingController = useTextEditingController();
    final lastNameEditingController = useTextEditingController();
    final emailEditingController = useTextEditingController();
    final phoneEditingController = useTextEditingController();

    final viewNode = useFocusNode();
    final usernameNode = useFocusNode();
    final firstNameNode = useFocusNode();
    final lastNameNode = useFocusNode();
    final emailNode = useFocusNode();
    final phoneNode = useFocusNode();

    usernameEditingController.text = user.username;
    firstNameEditingController.text = user.firstName ?? "";
    lastNameEditingController.text = user.lastName ?? "";
    phoneEditingController.text = user.phone ?? "";
    emailEditingController.text = user.email ?? "";

    success(User user) {
      snackBar.hideAll();
      snackBar.showSnackBar(text: "Update ${user.username} success");
      onSuccess(user);
    }

    final update = useUpdateUserLoading(context, onSuccess: success);

    getUserParam() {
      return UpdateUserParam(
        userId: user.id,
        userParam: UserParam(
          firstName: firstNameEditingController.text,
          lastName: lastNameEditingController.text,
          phone: phoneEditingController.text,
          email: emailEditingController.text,
        ),
      );
    }

    buildUpdateButton() {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ButtonWidget(
          key: const Key("update"),
          onClicked: () {
            FocusScope.of(context).requestFocus(viewNode);
            update(getUserParam());
          },
          text: "Update",
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
        buildTextFormField(
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
        buildTextFormField(
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
        buildUpdateButton(),
      ],
    );
  });
}
