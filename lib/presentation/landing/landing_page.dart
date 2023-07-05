import 'package:common/app_config.dart';
import 'package:flutter/material.dart';
import 'package:common/theme.dart';
import 'package:um/container.dart';
import 'package:um/core/stacked_view.dart';
import 'package:um/presentation/constants.dart';
import 'package:um/presentation/landing/landing_state.dart';
import 'package:um/presentation/landing/landing_view_model.dart';

class LandingPage extends StackedView<LandingViewModel> {
  final _config = sl<AppConfig>();

  LandingPage({super.key});

  @override
  Widget builder(BuildContext context, LandingViewModel viewModel) {
    return Scaffold(
      body: _buildLoading(),
    );
  }

  @override
  onDispose() {}

  @override
  onViewModelReady(LandingViewModel viewModel) {
    viewModel.getSystem();
  }

  @override
  LandingViewModel viewModelBuilder(BuildContext context) {
    final viewModel = sl<LandingViewModel>();
    viewModel.states.listen((state) {
      if (state is SystemState) {
        if (state.data.systemCode == _config.system) {
          Navigator.pushNamedAndRemoveUntil(context, _config.home, (r) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, routeError, (r) => false);
        }
      } else if (state is ErrorState) {
        Navigator.pushNamedAndRemoveUntil(context, routeError, (r) => false);
      }
    });
    return viewModel;
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

}
