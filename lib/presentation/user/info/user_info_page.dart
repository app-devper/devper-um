import 'package:common/core/utils/extension.dart';
import 'package:common/core/widget/custom_snack_bar.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/core/hook/use_update_user.dart';
import 'package:um/presentation/core/widget/build_user.dart';
import 'package:um/presentation/core/hook/use_user_info.dart';

class UserInfoPage extends HookWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final snackBar = CustomSnackBar(key: const Key("snackbar"), context: context);

    final viewNode = useFocusNode();
    final stream = useStreamController<User>();
    final userInfo = useUserInfo(stream);

    final edit = useState(false);

    success(User user) {
      snackBar.hideAll();
      snackBar.showSnackBar(text: "Update ${user.username} success");
      edit.value = true;
      stream.add(user);
    }

    final update = useUpdateUserInfo(context, onSuccess: success);

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
                update(param.userParam);
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
        body: buildBody(),
      ),
    );
  }
}
