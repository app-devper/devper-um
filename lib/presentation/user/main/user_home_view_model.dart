import 'package:common/core/error/failures.dart';
import 'package:flutter/material.dart';
import 'package:um/core/view_model/view_model.dart';
import 'package:um/domain/usecases/auth/logout_user.dart';

import 'user_home_state.dart';

class UserHomeViewModel extends ViewModel<UserHomeState> {
  final LogoutUser _logoutUser;

  final viewNode = FocusNode();

  UserHomeViewModel(this._logoutUser);

  logout() {
    _onLoading();
    _logoutUser().then((value) => value.fold(onSuccess: _onLogout, onError: _onError));
  }

  _onLoading() {
    emitEvent(LoadingState());
  }

  _onLogout(bool data) {
    emitEvent(LogoutState());
  }

  _onError(Failure failure) {
    emitEvent(LogoutState());
  }

  @override
  dispose() {
    super.dispose();
    viewNode.dispose();
  }
}
