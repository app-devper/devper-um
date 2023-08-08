import 'package:common/core/widget/dialog_widget.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:um/container.dart';
import 'package:um/core/view_model/stacked_view.dart';
import 'package:um/presentation/constants.dart';

import 'user_home_state.dart';
import 'user_home_view_model.dart';

class UserHomePage extends StackedView<UserHomeViewModel> {
  const UserHomePage({super.key});

  @override
  Widget builder(BuildContext context, UserHomeViewModel viewModel) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(viewModel.viewNode),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: CustomTheme.mainTheme.iconTheme,
          backgroundColor: CustomColor.white,
          centerTitle: true,
          title: Text(
            "Home",
            style: CustomTheme.mainTheme.textTheme.headline5,
          ),
          actions: _buildAction(context, viewModel),
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: CustomColor.statusBarColor,
          ),
          child: _buildBody(context),
        ),
      ),
    );
  }

  @override
  onDispose() {}

  @override
  onViewModelReady(UserHomeViewModel viewModel) {}

  @override
  UserHomeViewModel viewModelBuilder(BuildContext context) {
    final viewModel = sl<UserHomeViewModel>();
    viewModel.states.listen((state) {
      if (state is ErrorState) {
        hideLoadingDialog(context);
      } else if (state is LoadingState) {
        showLoadingDialog(context);
      } else if (state is LogoutState) {
        hideLoadingDialog(context);
        Navigator.popAndPushNamed(context, routeLogin);
      }
    });
    return viewModel;
  }

  _buildAction(BuildContext context, UserHomeViewModel viewModel) {
    return [
      PopupMenuButton<int>(
        icon: const Icon(Icons.more_vert),
        onSelected: (item) => _handleClick(context, item, viewModel),
        itemBuilder: (context) => [
          const PopupMenuItem<int>(value: 0, child: Text("User List")),
          const PopupMenuItem<int>(value: 1, child: Text("User Info")),
          const PopupMenuItem<int>(value: 2, child: Text("Change Password")),
          const PopupMenuItem<int>(value: 3, child: Text('Logout')),
        ],
      ),
    ];
  }

  _handleClick(BuildContext context, int item, UserHomeViewModel viewModel) {
    switch (item) {
      case 0:
        Navigator.pushNamed(context, routeUsers);
        break;
      case 1:
        Navigator.pushNamed(context, routeUserInfo);
        break;
      case 2:
        Navigator.pushNamed(context, routeChangePassword);
        break;
      case 3:
        viewModel.logout();
        break;
    }
  }

  _buildBody(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      padding: const EdgeInsets.all(defaultPagePadding),
      child: const Column(
        children: <Widget>[],
      ),
    );
  }
}
