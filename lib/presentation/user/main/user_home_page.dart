import 'package:common/core/widget/custom_snack_bar.dart';
import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:um/container.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/user/main/user_home_state.dart';
import 'package:um/presentation/user/main/user_home_view_model.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage>{
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late CustomSnackBar _snackBar;

  late UserHomeViewModel _viewModel;

  final FocusNode _viewNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _viewModel = sl<UserHomeViewModel>();
    _viewModel.states.listen((state) {
      if (state is ErrorState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _snackBar.hideAll();
          _snackBar.showErrorSnackBar(state.message);
        });
      } else if (state is LoadingState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _snackBar.hideAll();
          _snackBar.showLoadingSnackBar();
        });
      } else if (state is LogoutState) {
        Navigator.popAndPushNamed(context, routeLogin);
      }
    });
  }

  @override
  void dispose() {
    _viewNode.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _snackBar = CustomSnackBar(key: const Key("snackbar"), context: context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_viewNode),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: CustomTheme.mainTheme.iconTheme,
          backgroundColor: CustomColor.white,
          centerTitle: true,
          title: Text(
           "Home",
            style: CustomTheme.mainTheme.textTheme.headline5,
          ),
          actions: _buildAction(context),
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

  List<Widget> _buildAction(BuildContext context) {
    return [
      PopupMenuButton<int>(
        icon: const Icon(Icons.more_vert),
        onSelected: (item) => handleClick(item),
        itemBuilder: (context) => [
          const PopupMenuItem<int>(value: 0, child: Text("User List")),
          const PopupMenuItem<int>(value: 1, child: Text("User Info")),
          const PopupMenuItem<int>(value: 2, child: Text("Change Password")),
          const PopupMenuItem<int>(value: 3, child: Text('Logout')),
        ],
      ),
    ];
  }

  void handleClick(int item) {
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
        _viewModel.logout();
        break;
    }
  }

  Widget _buildBody(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      padding: const EdgeInsets.all(defaultPagePadding),
      child: const Column(
        children: <Widget>[

        ],
      ),
    );
  }

}
