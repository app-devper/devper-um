import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/core/hook/use_users.dart';
import 'package:um/presentation/user/argument.dart';
import 'package:um/presentation/core/widget/build_users.dart';

class UsersPage extends HookWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reloadKey = useState(UniqueKey());
    final controller = useStreamController<List<User>>();
    final users = useUsersStream(reloadKey, controller);

    reload(result) {
      if (result != null && result is bool) {
        if (result) {
          reloadKey.value = UniqueKey();
        }
      }
    }

    nextToUserEdit(String userId) async {
      final result = await Navigator.pushNamed(context, routeUserEdit, arguments: UserArgument(userId));
      reload(result);
    }

    nextToUserAdd() async {
      final result = await Navigator.pushNamed(context, routeUserAdd);
      reload(result);
    }

    buildAction() {
      return [
        IconButton(
          onPressed: () {
            nextToUserAdd();
          },
          icon: const Icon(Icons.add),
        ),
      ];
    }

    useEffect(() {
      return () {
        controller.close();
      };
    }, []);

    return Scaffold(
      appBar: AppBar(
        iconTheme: CustomTheme.mainTheme.iconTheme,
        backgroundColor: CustomColor.white,
        centerTitle: true,
        title: Text(
          "Users",
          style: CustomTheme.mainTheme.textTheme.headline5,
        ),
        actions: buildAction(),
      ),
      body: buildUsers(users, (user) {
        nextToUserEdit(user.id);
      }),
    );
  }
}
