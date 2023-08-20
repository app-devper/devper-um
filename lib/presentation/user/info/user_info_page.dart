import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/core/ext/extensions.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/core/widget/build_user.dart';
import 'package:um/presentation/core/hook/use_user_info.dart';

class UserInfoPage extends HookWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewNode = useFocusNode();
    final userInfo = useUserInfo();

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

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(viewNode),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: CustomTheme.mainTheme.iconTheme,
          backgroundColor: CustomColor.white,
          centerTitle: true,
          title: Text(
            "User Info",
            style: CustomTheme.mainTheme.textTheme.headline5,
          ),
        ),
        body: buildBody(userInfo),
      ),
    );
  }
}
