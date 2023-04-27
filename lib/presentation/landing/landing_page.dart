import 'package:common/app_config.dart';
import 'package:flutter/material.dart';
import 'package:common/theme.dart';
import 'package:um/container.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/landing/landing_state.dart';
import 'package:um/presentation/landing/landing_view_model.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late LandingViewModel _viewModel;
  late AppConfig _config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildLoading(),
    );
  }

  _buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Center(
            child: CircularProgressIndicator(
              color: CustomColor.backgroundMain,
            ),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _config = sl<AppConfig>();
    _viewModel = sl<LandingViewModel>();
    _viewModel.states.stream.listen((state) {
      if (state is SystemState) {
        if (state.data.systemCode == _config.system) {
          Navigator.pushNamedAndRemoveUntil(context, _config.home, (r) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, ERROR_ROUTE, (r) => false);
        }
      } else if (state is ErrorState) {
        Navigator.pushNamedAndRemoveUntil(context, ERROR_ROUTE, (r) => false);
      }
    });
    _viewModel.getSystem();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
