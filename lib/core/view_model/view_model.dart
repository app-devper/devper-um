import 'dart:async';

import 'package:flutter/cupertino.dart';

abstract class ViewModel<Event> extends ChangeNotifier {
  bool disposed = false;

  @protected
  final StreamController<Event> _eventController = StreamController<Event>();
  Stream<Event> get eventStream => _eventController.stream;

  @protected
  void emitEvent(Event event) {
    if (!_eventController.isClosed) {
      _eventController.sink.add(event);
    }
  }

  @override
  void notifyListeners() {
    if (!disposed) {
      super.notifyListeners();
    }
  }

  /// Calls the builder function with this updated viewmodel
  @protected
  void rebuildUi() {
    notifyListeners();
  }

  @protected
  void updateUi(Function block) {
    block();
    notifyListeners();
  }

  @override
  void dispose() {
    _eventController.close();
    disposed = true;
    super.dispose();
  }
}
