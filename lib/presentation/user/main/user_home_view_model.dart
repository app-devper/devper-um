import 'dart:async';
import 'package:common/core/error/failures.dart';
import 'package:flutter/material.dart';
import 'package:um/core/view_model/view_model.dart';
import 'package:um/domain/usecases/auth/logout_user.dart';

import 'user_home_state.dart';

class UserHomeViewModel extends ViewModel {
  final LogoutUser _logoutUser;

  final viewNode = FocusNode();

  UserHomeViewModel(
     this._logoutUser
  );

  final _states = StreamController<UserHomeState>();

  Stream<UserHomeState> get states => _states.stream;

  logout() {
    _onLoading();
    _logoutUser().then((value) => value.fold(onSuccess: _onLogout, onError: _onError));
  }

  _onLoading() {
    _states.sink.add(LoadingState());
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
    viewNode.dispose();
  }
}
