import 'package:flutter/material.dart';
import 'package:common/theme.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  SafeArea _buildBody(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      bottom: true,
      child: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 150)),
            Expanded(
              child: Text(
                "Error Page",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: CustomColor.font7,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
    );
  }

  List<Widget> _buildAction() {
    return [
      IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.close,
          color: CustomColor.font7,
        ),
      ),
    ];
  }
}
