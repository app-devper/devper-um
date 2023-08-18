import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'view_model.dart';

class ViewModelBuilder<VM extends ViewModel<Event>, Event> extends StatefulWidget {
  final bool _nonReactive;

  final Function(VM viewModel) onViewModelReady;

  final Widget Function(BuildContext context, VM viewModel) builder;

  final void Function(BuildContext, VM, Event)? onEventEmitted;

  final VM Function() viewModelBuilder;

  final Function() onDispose;

  const ViewModelBuilder({
    super.key,
    required this.viewModelBuilder,
    required this.builder,
    required this.onViewModelReady,
    required this.onDispose,
    this.onEventEmitted,
  }) : _nonReactive = false;

  /// Constructor that creates a [ViewModel] view that doesn't rebuild when the [ViewModel] calls notifyListeners();
  const ViewModelBuilder.nonReactive({
    super.key,
    required this.viewModelBuilder,
    required this.builder,
    required this.onViewModelReady,
    required this.onDispose,
    this.onEventEmitted,
  }) : _nonReactive = true;

  @override
  State<ViewModelBuilder> createState() => _ViewModelBuilderState<VM, Event>();
}

class _ViewModelBuilderState<VM extends ViewModel<Event>, Event> extends State<ViewModelBuilder<VM, Event>> {
  late VM _viewModel;
  StreamSubscription<Event>? _eventSubscription;

  @override
  initState() {
    super.initState();
    _createViewModel();
  }

  _createViewModel() {
    _viewModel = widget.viewModelBuilder();
    if (widget.onEventEmitted != null) {
      _eventSubscription = _viewModel.eventStream.listen((event) {
        widget.onEventEmitted?.call(context, _viewModel, event);
      });
    }
    widget.onViewModelReady(_viewModel);
  }

  @override
  dispose() {
    super.dispose();
    _eventSubscription?.cancel();
    _eventSubscription = null;
    widget.onDispose.call();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VM>(
      create: (context) => _viewModel,
      child: Consumer<VM>(
        builder: builder,
      ),
    );
  }

  Widget builder(BuildContext context, VM viewModel, Widget? child) {
    return widget.builder(
      context,
      viewModel,
    );
  }
}

T getParentViewModel<T>(BuildContext context, {bool listen = true}) => Provider.of<T>(context, listen: listen);
