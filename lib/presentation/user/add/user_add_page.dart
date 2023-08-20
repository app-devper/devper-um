import 'package:common/data/session/app_session_provider.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/core/widget/build_add_user.dart';

class UserAddPage extends HookWidget {
  const UserAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewNode = useFocusNode();
    final add = useState(false);

    buildBody() {
      final appSession = sl<AppSessionProvider>();
      return SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPagePadding),
        child: buildAddUser(appSession.getClientId(), (user) {
          add.value = true;
        }),
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
            "Add User",
            style: CustomTheme.mainTheme.textTheme.headline5,
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, add.value);
            return false;
          },
          child: buildBody(),
        ),
      ),
    );
  }
}
