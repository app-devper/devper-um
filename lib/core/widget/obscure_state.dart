import 'package:flutter/material.dart';

class ObscureState extends ChangeNotifier {
  bool _isTrue = true;
  bool get isTrue => _isTrue;

  get switchObsIcon {
    return _isTrue ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility);
  }

  toggleObs() {
    _isTrue = !_isTrue;
    notifyListeners();
  }
}
