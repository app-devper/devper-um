
import 'package:flutter/widgets.dart';
import 'package:um/core/view_model.dart';
import 'package:um/core/view_model_builder.dart';

abstract class StackedView<T extends ViewModel> extends StatelessWidget {
  const StackedView({Key? key}) : super(key: key);

  Widget builder(BuildContext context, T viewModel);

  T viewModelBuilder(BuildContext context);

  onViewModelReady(T viewModel);

  onDispose();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<T>.reactive(
      builder: builder,
      viewModelBuilder: () => viewModelBuilder(context),
      onViewModelReady: onViewModelReady,
      onDispose: onDispose,
    );
  }

}
