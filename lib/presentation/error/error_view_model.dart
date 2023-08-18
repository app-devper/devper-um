import 'package:common/core/error/failures.dart';
import 'package:um/core/view_model/view_model.dart';
import 'package:um/domain/usecases/auth/logout_user.dart';

import 'error_state.dart';

class ErrorViewModel extends ViewModel<ErrorState> {
  final LogoutUser _logoutUser;

  ErrorViewModel(this._logoutUser);

  void logout() {
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
}
