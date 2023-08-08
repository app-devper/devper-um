import 'package:flutter/cupertino.dart';

abstract class ViewModel extends ChangeNotifier {
  bool disposed = false;

  @override
  void notifyListeners() {
    if (!disposed) {
      super.notifyListeners();
    }
  }

  /// Calls the builder function with this updated viewmodel
  void rebuildUi() {
    notifyListeners();
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}
