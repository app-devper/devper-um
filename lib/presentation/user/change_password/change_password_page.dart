import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/core/widget/build_change_password.dart';

class ChangePasswordPage extends HookWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewNode = useFocusNode();

    buildBody() {
      final Size size = MediaQuery.of(context).size;
      return Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(defaultPagePadding),
        child: SingleChildScrollView(
          child: buildChangePassword(),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(viewNode),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: CustomTheme.mainTheme.iconTheme,
          backgroundColor: CustomColor.white,
          centerTitle: true,
          title: Text(
            "Change Password",
            style: CustomTheme.mainTheme.textTheme.headline5,
          ),
        ),
        body: buildBody(),
      ),
    );
  }
}
