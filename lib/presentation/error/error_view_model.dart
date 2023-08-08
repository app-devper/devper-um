import 'dart:async';
import 'package:common/core/error/failures.dart';
import 'package:um/core/view_model/view_model.dart';
import 'package:um/domain/usecases/auth/logout_user.dart';

import 'error_state.dart';

class ErrorViewModel extends ViewModel {

  final LogoutUser _logoutUser;

  ErrorViewModel(this._logoutUser);

  final _states = StreamController<ErrorState>();

  Stream<ErrorState> get states => _states.stream;

  void logout() {
    _onLoading();
    _logoutUser().then((value) => value.fold(onSuccess: _onLogout, onError: _onError));
  }

  _onLoading() {
    if (!_states.isClosed) {
      _states.sink.add(LoadingState());
    }
  }

  _onLogout(bool data) {
    if (!_states.isClosed) {
      _states.sink.add((LogoutState()));
    }
  }

  _onError(Failure failure) {
    if (!_states.isClosed) {
      _states.sink.add((LogoutState()));
    }
  }


  @override
  dispose() {
    super.dispose();
    _states.close();
  }
}
