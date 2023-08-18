import 'package:flutter/widgets.dart';
import 'view_model.dart';
import 'view_model_builder.dart';

abstract class StackedView<T extends ViewModel<Event>, Event> extends StatelessWidget {
  const StackedView({Key? key}) : super(key: key);

  Widget builder(BuildContext context, T viewModel);

  T viewModelBuilder(BuildContext context);

  onViewModelReady(T viewModel);

  onDispose();

  onEventEmitted(BuildContext context, T viewModel, Event event);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder(
      builder: builder,
      viewModelBuilder: () => viewModelBuilder(context),
      onViewModelReady: onViewModelReady,
      onDispose: onDispose,
      onEventEmitted: onEventEmitted,
    );
  }
}
