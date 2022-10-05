import 'package:flutter/material.dart';
import 'package:um/presentation/error/error_page.dart';
import 'package:um/presentation/landing/landing_page.dart';

import 'constants.dart';
import 'login/login_page.dart';
import 'user/add/user_add_page.dart';
import 'user/argument.dart';
import 'user/change_password/change_password_page.dart';
import 'user/edit/user_edit_page.dart';
import 'user/info/user_info_page.dart';
import 'user/main/users_page.dart';

class RouterUm {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LOGIN_ROUTE:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case CHANGE_PASSWORD_ROUTE:
        return MaterialPageRoute(builder: (_) => ChangePasswordPage());
      case USERS_ROUTE:
        return MaterialPageRoute(builder: (_) => UsersPage());
      case USER_INFO_ROUTE:
        return MaterialPageRoute(builder: (_) => UserInfoPage());
      case USER_ADD_ROUTE:
        return MaterialPageRoute(builder: (_) => UserAddPage());
      case USER_EDIT_ROUTE:
        final args = settings.arguments as UserArgument;
        return MaterialPageRoute(builder: (_) => UserEditPage(userId: args.user.id));
      case USER_HOME_ROUTE:
        return MaterialPageRoute(builder: (_) => UsersPage());
      case LANDING_ROUTE:
        return MaterialPageRoute(builder: (_) => LandingPage());
      default:
        return MaterialPageRoute(builder: (_) => ErrorPage());
    }
  }
}
