import 'package:flutter/material.dart';
import 'package:um/presentation/error/error_page.dart';
import 'package:um/presentation/not_found/not_found_page.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/login/login_page.dart';
import 'package:um/presentation/user/add/user_add_page.dart';
import 'package:um/presentation/user/argument.dart';
import 'package:um/presentation/user/change_password/change_password_page.dart';
import 'package:um/presentation/user/edit/user_edit_page.dart';
import 'package:um/presentation/user/info/user_info_page.dart';
import 'package:um/presentation/user/list/users_page.dart';
import 'package:um/presentation/user/main/user_home_page.dart';

class RouterUm {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeLogin:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case routeChangePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordPage());
      case routeUsers:
        return MaterialPageRoute(builder: (_) => const UsersPage());
      case routeUserInfo:
        return MaterialPageRoute(builder: (_) => const UserInfoPage());
      case routeUserAdd:
        return MaterialPageRoute(builder: (_) => const UserAddPage());
      case routeUserEdit:
        final args = settings.arguments as UserArgument;
        return MaterialPageRoute(builder: (_) => UserEditPage(userId: args.userId));
      case routeUserHome:
        return MaterialPageRoute(builder: (_) => const UserHomePage());
      case routeError:
        return MaterialPageRoute(builder: (_) => const ErrorPage());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
