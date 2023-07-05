import 'package:flutter/widgets.dart';
import 'package:um/core/view_model.dart';

class ViewModelBuilder<T extends ViewModel> extends StatefulWidget {
  final Function(T viewModel) onViewModelReady;

  final Widget Function(BuildContext context, T viewModel) builder;

  final T Function() viewModelBuilder;

  final Function() onDispose;

  const ViewModelBuilder.reactive({
    required this.viewModelBuilder,
    required this.builder,
    required this.onViewModelReady,
    required this.onDispose,
    Key? key,
  }) : super(key: key);

  @override
  ViewModelBuilderState<T> createState() => ViewModelBuilderState<T>();
}

class ViewModelBuilderState<T extends ViewModel> extends State<ViewModelBuilder<T>> {
  late T _viewModel;

  @override
  initState() {
    super.initState();
    _createViewModel();
  }

  _createViewModel() {
    _viewModel = widget.viewModelBuilder();
    widget.onViewModelReady(_viewModel);
  }

  @override
  dispose() {
    super.dispose();
    _viewModel.dispose();
    widget.onDispose.call();
  }

  @override
  Widget build(BuildContext context) {
    return builder(context, _viewModel);
  }

  Widget builder(BuildContext context, T viewModel) {
    return widget.builder(
      context,
      viewModel,
    );
  }
}
