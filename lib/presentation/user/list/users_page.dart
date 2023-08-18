import 'package:common/core/widget/custom_snack_bar.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:um/core/ext/extensions.dart';
import 'package:um/container.dart';
import 'package:um/core/view_model/stacked_view.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/user/argument.dart';

import 'users_state.dart';
import 'users_view_model.dart';

class UsersPage extends StackedView<UsersViewModel, UsersState> {
  late CustomSnackBar snackBar;

  UsersPage({super.key});

  @override
  Widget builder(BuildContext context, UsersViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: CustomTheme.mainTheme.iconTheme,
        backgroundColor: CustomColor.white,
        centerTitle: true,
        title: Text(
          "Users",
          style: CustomTheme.mainTheme.textTheme.headline5,
        ),
        actions: _buildAction(context, viewModel),
      ),
      body: _buildBody(context, viewModel),
    );
  }

  @override
  onDispose() {}

  @override
  onViewModelReady(UsersViewModel viewModel) {
    viewModel.getUsers();
  }

  @override
  UsersViewModel viewModelBuilder(BuildContext context) {
    snackBar = CustomSnackBar(key: const Key("snackBar"), context: context);
    final viewModel = sl<UsersViewModel>();
    return viewModel;
  }

  @override
  onEventEmitted(BuildContext context, UsersViewModel viewModel, UsersState event) {
    if (event is ErrorState) {
      snackBar.hideAll();
      snackBar.showErrorSnackBar(event.message);
      viewModel.setUsers(List.empty());
    } else if (event is LoadingState) {
    } else if (event is ListUserState) {
      viewModel.setUsers(event.data);
    }
  }

  _buildAction(BuildContext context, UsersViewModel viewModel) {
    return [
      IconButton(
        onPressed: () {
          _nextToUserAdd(context, viewModel);
        },
        icon: const Icon(Icons.add),
      ),
    ];
  }

  _buildBody(BuildContext context, UsersViewModel viewModel) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildUserList(context, viewModel),
      ],
    );
  }

  _buildUserList(BuildContext context, UsersViewModel viewModel) {
    return viewModel.users.toWidgetLoading(
      widgetBuilder: (data) => Expanded(
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final content = data[index];
            return ListTile(
              title: Text(content.username),
              subtitle: Text(content.role),
              onTap: () {
                _nextToUserEdit(context, content.id, viewModel);
              },
            );
          },
        ),
      ),
    );
  }

  _nextToUserEdit(BuildContext context, String userId, UsersViewModel viewModel) async {
    final result = await Navigator.pushNamed(context, routeUserEdit, arguments: UserArgument(userId));
    viewModel.getUsers();
  }

  _nextToUserAdd(BuildContext context, UsersViewModel viewModel) async {
    final result = await Navigator.pushNamed(context, routeUserAdd);
    viewModel.getUsers();
  }
}
