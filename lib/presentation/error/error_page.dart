import 'package:common/core/widget/button_widget.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:um/container.dart';
import 'package:um/core/stacked_view.dart';
import 'package:um/presentation/constants.dart';

import 'error_state.dart';
import 'error_view_model.dart';

class ErrorPage extends StackedView<ErrorViewModel> {
  const ErrorPage({super.key});

  @override
  Widget builder(BuildContext context, ErrorViewModel viewModel) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  @override
  onDispose() {}

  @override
  onViewModelReady(ErrorViewModel viewModel) {
    viewModel.logout();
  }

  @override
  ErrorViewModel viewModelBuilder(BuildContext context) {
    final viewModel = sl<ErrorViewModel>();
    viewModel.states.listen((state) {
      if (state is LoadingState) {
      } else if (state is LogoutState) {}
    });
    return viewModel;
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
            _buildAddButton(context),
          ],
        ),
      ),
    );
  }

  _buildAddButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ButtonWidget(
        key: const Key("ToLogin"),
        onClicked: () {
          Navigator.popAndPushNamed(context, routeLogin);
        },
        text: "To Login",
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
}
