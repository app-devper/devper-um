import 'package:common/core/widget/dialog_widget.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/core/hook/use_logout.dart';

class UserHomePage extends HookWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewNode = useFocusNode();
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(viewNode),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: CustomTheme.mainTheme.iconTheme,
          backgroundColor: CustomColor.white,
          centerTitle: true,
          title: Text(
            "Home",
            style: CustomTheme.mainTheme.textTheme.headlineSmall,
          ),
          actions: _buildAction(context),
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: CustomColor.statusBarColor,
          ),
          child: _buildBody(context),
        ),
      ),
    );
  }

  _buildAction(BuildContext context) {
    final logout = useLogout(onSuccess: () {
      Navigator.popAndPushNamed(context, routeLogin);
    });
    return [
      PopupMenuButton<int>(
        icon: const Icon(Icons.more_vert),
        onSelected: (item) {
          switch (item) {
            case 0:
              Navigator.pushNamed(context, routeUsers);
              break;
            case 1:
              Navigator.pushNamed(context, routeUserInfo);
              break;
            case 2:
              Navigator.pushNamed(context, routeChangePassword);
              break;
            case 3:
              logout();
              break;
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem<int>(value: 0, child: Text("User List")),
          const PopupMenuItem<int>(value: 1, child: Text("User Info")),
          const PopupMenuItem<int>(value: 2, child: Text("Change Password")),
          const PopupMenuItem<int>(value: 3, child: Text('Logout')),
        ],
      ),
    ];
  }

  _buildBody(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      padding: const EdgeInsets.all(defaultPagePadding),
      child: const Column(
        children: <Widget>[],
      ),
    );
  }
}
