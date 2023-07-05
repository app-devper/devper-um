import 'dart:async';
import 'package:common/core/error/failures.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/usecases/auth/get_login.dart';
import 'package:um/domain/usecases/auth/logout_user.dart';

import 'user_home_state.dart';

class UserHomeViewModel {
  final GetLogin getLoginUseCase;
  final LogoutUser logOutUseCase;

  UserHomeViewModel({
    required this.getLoginUseCase,
    required this.logOutUseCase,
  });

  final _states = StreamController<UserHomeState>();

  Stream<UserHomeState> get states => _states.stream;

  void prepareData() {
    getLoginUseCase(GetLoginParam()).then((value) => {
          value.fold((l) {
            _onError(l);
          }, (r) {
            _onCheckLoginSuccess(r);
          })
        });
  }

  void logout() {
    logOutUseCase(LogOutParams()).then((value) => {
          value.fold((l) {
            _onLogoutSuccess();
          }, (r) {
            _onLogoutSuccess();
          })
        });
  }

  _onLoading() {
    _states.sink.add(LoadingState());
  }

  _onCheckLoginSuccess(bool isLogin) {
    _states.sink.add((LoggedState(isLogin)));
  }

  _onLogoutSuccess() {
    _states.sink.add((LogoutState()));
  }

  _onError(Failure failure) {
    if (!_states.isClosed) {
      _states.sink.add(ErrorState(failure.error));
    }
  }

  dispose() {
    _states.close();
  }
}
