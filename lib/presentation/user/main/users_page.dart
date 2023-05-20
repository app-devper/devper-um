import 'package:common/core/widget/custom_snack_bar.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/container.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/user/argument.dart';
import 'package:um/presentation/user/main/users_state.dart';
import 'package:um/presentation/user/main/users_view_model.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<StatefulWidget> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late CustomSnackBar _snackBar;
  late UsersViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<UsersViewModel>();
    _viewModel.states.stream.listen((state) {
      if (state is ErrorState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _snackBar.hideAll();
          _snackBar.showErrorSnackBar(state.message);
        });
      } else if (state is LoadingState) {
      } else if (state is ListUserState) {
        _viewModel.setUsers(state.data);
      } else if (state is LoggedState) {}
    });

    _viewModel.getUsers();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _snackBar = CustomSnackBar(key: const Key("snackbar"), context: context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: CustomTheme.mainTheme.iconTheme,
        backgroundColor: CustomColor.white,
        centerTitle: true,
        title: Text(
          "Users",
          style: CustomTheme.mainTheme.textTheme.headline5,
        ),
        actions: _buildAction(context),
      ),
      body: _buildBody(context),
    );
  }

  List<Widget> _buildAction(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          _nextToUserAdd(context);
        },
        icon: const Icon(Icons.add),
      ),
    ];
  }

  Widget _buildBody(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildUserList(),
      ],
    );
  }

  _buildUserList() {
    return StreamBuilder(
      stream: _viewModel.users.stream,
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.requireData;
          return _buildUser(data);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _buildUser(List<User> item) {
    return Expanded(
      child: ListView.builder(
        itemCount: item.length,
        itemBuilder: (context, index) {
          final content = item[index];
          return ListTile(
            title: Text(content.username),
            subtitle: Text(content.role),
            onTap: () {
              _nextToUserEdit(context, content.id);
            },
          );
        },
      ),
    );
  }

  _nextToUserEdit(BuildContext context, String userId) async {
    var result = await Navigator.pushNamed(context, USER_EDIT_ROUTE, arguments: UserArgument(userId));
    _viewModel.getUsers();
  }

  _nextToUserAdd(BuildContext context) async {
    var result = await Navigator.pushNamed(context, USER_ADD_ROUTE);
    _viewModel.getUsers();
  }
}
