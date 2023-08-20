import 'package:common/core/utils/extension.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/core/ext/extensions.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/presentation/constants.dart';

import 'package:um/presentation/core/hook/use_remove_user.dart';
import 'package:um/presentation/core/hook/use_user_id.dart';
import 'package:um/presentation/core/widget/build_user.dart';

class UserEditPage extends HookWidget {
  final String userId;

  const UserEditPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final viewNode = useFocusNode();
    final userInfo = useUserId(userId);
    final userSnapshot = useStream(userInfo);
    final edit = useState(false);

    buildBody(Stream<User> userInfo) {
      return userInfo.toWidgetLoading(
        widgetBuilder: (data) => SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPagePadding),
          child: buildUser(data, (user) {
            edit.value = true;
          }),
        ),
      );
    }

    success(User data) {
      edit.value = true;
      Navigator.pop(context, edit.value);
    }

    final remove = useRemoveUserLoading(context, onSuccess: success);

    confirm(User user) {
      showConfirmDialog(context, "แจ้งเตือน", "ต้องการลบผู้ใช้งาน ${user.username} ใช่หรือไม่?", () {
        remove(user.id);
      });
    }

    buildAction(User user) {
      return [
        IconButton(
          onPressed: () {
            confirm(user);
          },
          icon: const Icon(Icons.delete),
        ),
      ];
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(viewNode),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: CustomTheme.mainTheme.iconTheme,
          backgroundColor: CustomColor.white,
          centerTitle: true,
          title: Text(
            "Edit User",
            style: CustomTheme.mainTheme.textTheme.headline5,
          ),
          actions: userSnapshot.hasData ? buildAction(userSnapshot.requireData) : [],
        ),
        body: buildBody(userInfo),
      ),
    );
  }
}
