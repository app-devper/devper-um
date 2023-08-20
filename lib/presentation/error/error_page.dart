import 'package:common/core/widget/button_widget.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/core/ext/extensions.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/core/hook/use_auto_logout.dart';

class ErrorPage extends HookWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final autoLogout = useAutoLogout();

    buildError(Function() onClicked) {
      buildToLoginButton() {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ButtonWidget(
            key: const Key("ToLogin"),
            onClicked: () {
              onClicked();
            },
            text: "To Login",
          ),
        );
      }

      return Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(top: 150)),
          Text(
            "Error Page",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: CustomColor.font7,
            ),
            textAlign: TextAlign.center,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 14),
          ),
          buildToLoginButton(),
        ],
      );
    }

    buildBody() {
      final Size size = MediaQuery.of(context).size;
      return SafeArea(
        bottom: true,
        child: Container(
          height: size.height,
          width: size.width,
          padding: const EdgeInsets.all(20),
          child: autoLogout.toWidgetLoading(widgetBuilder: (_) {
            return buildError(() {
              Navigator.popAndPushNamed(context, routeLogin);
            });
          }),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Text(
          "Error",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: CustomColor.font7,
          ),
        ),
      ),
      body: buildBody(),
    );
  }
}
