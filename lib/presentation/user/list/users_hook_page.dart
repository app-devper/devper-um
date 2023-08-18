import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/core/ext/extensions.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/user/argument.dart';
import 'package:um/presentation/user/list/hook/use_users.dart';


class UsersHookPage extends HookWidget {

  const UsersHookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: CustomTheme.mainTheme.iconTheme,
        backgroundColor: CustomColor.white,
        centerTitle: true,
        title: Text(
          "Users",
          style: CustomTheme.mainTheme.textTheme.headline5,
        ),
        actions: _buildAction(context),
      ),
      body: _buildBody(context),
    );
  }

  _buildAction(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          _nextToUserAdd(context);
        },
        icon: const Icon(Icons.add),
      ),
    ];
  }

  _buildBody(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildUserList(context),
      ],
    );
  }

  _buildUserList(BuildContext context) {
    final users = useUsers();
    return users.toWidgetLoading(
      widgetBuilder: (data) => Expanded(
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final content = data[index];
            return ListTile(
              title: Text(content.username),
              subtitle: Text(content.role),
              onTap: () {
                _nextToUserEdit(context, content.id);
              },
            );
          },
        ),
      ),
    );
  }

  _nextToUserEdit(BuildContext context, String userId) async {
    final result = await Navigator.pushNamed(context, routeUserEdit, arguments: UserArgument(userId));
  }

  _nextToUserAdd(BuildContext context) async {
    final result = await Navigator.pushNamed(context, routeUserAdd);
  }

}
