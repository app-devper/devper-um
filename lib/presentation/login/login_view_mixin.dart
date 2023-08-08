import 'package:flutter/material.dart';

mixin LoginViewMixin {
  final usernameEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();

  final usernameNode = FocusNode();
  final passwordNode = FocusNode();
  final viewNode = FocusNode();

  disposeView() {
    usernameEditingController.dispose();
    passwordEditingController.dispose();

    usernameNode.dispose();
    passwordNode.dispose();
    viewNode.dispose();
  }
}
