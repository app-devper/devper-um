import 'dart:async';

import 'package:common/core/error/failures.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/usecases/user/change_password.dart';

import 'change_password_state.dart';

class ChangePasswordViewModel {
  final ChangePassword changePasswordUseCase;

  final _states = StreamController<ChangePasswordState>();

  StreamController<ChangePasswordState> get states => _states;

  ChangePasswordViewModel({
    required this.changePasswordUseCase,
  });

  void changePassword(ChangePasswordParam param) {
    _onLoading();
    changePasswordUseCase(param).then((value) => {
          value.fold((l) {
            _onError(l);
          }, (r) {
            _onUpdatePassword();
          })
        });
  }

  _onLoading() {
    _states.sink.add(LoadingState());
  }

  _onUpdatePassword() {
    if (!_states.isClosed) {
      _states.sink.add(UpdatePasswordState());
    }
  }

  _onError(Failure failure) {
    if (!_states.isClosed) {
      _states.sink.add(ErrorState(message: failure.error));
    }
  }

  dispose() {
    _states.close();
  }
}
