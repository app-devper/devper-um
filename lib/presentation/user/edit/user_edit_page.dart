import 'package:common/core/utils/extension.dart';
import 'package:common/core/widget/custom_snack_bar.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/presentation/constants.dart';

import 'package:um/presentation/core/hook/use_remove_user.dart';
import 'package:um/presentation/core/hook/use_update_user.dart';
import 'package:um/presentation/core/hook/use_user_id.dart';
import 'package:um/presentation/core/widget/build_user.dart';

class UserEditPage extends HookWidget {
  final String userId;

  const UserEditPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final snackBar = CustomSnackBar(key: const Key("snackbar"), context: context);

    final viewNode = useFocusNode();
    final stream = useStreamController<User>();
    final userInfo = useUserId(userId, stream);
    final userSnapshot = useStream(userInfo);
    final edit = useState(false);

    success(User user) {
      snackBar.hideAll();
      snackBar.showSnackBar(text: "Update ${user.username} success");
      edit.value = true;
      stream.add(user);
    }

    final update = useUpdateUser(context, onSuccess: success);

    buildBody() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPagePadding),
        child: StreamBuilder(
          stream: userInfo,
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              return buildUser(snapshot.requireData, (param) {
                update(param);
              });
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: CustomColor.backgroundMain,
                  strokeCap: StrokeCap.round,
                ),
              );
            }
          },
        ),
      );
    }

    removeSuccess(User data) {
      Navigator.pop(context, true);
    }

    final remove = useRemoveUser(context, onSuccess: removeSuccess);

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
        body: buildBody(),
      ),
    );
  }
}
