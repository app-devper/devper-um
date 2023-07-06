import 'dart:async';
import 'package:common/core/error/failures.dart';
import 'package:um/domain/usecases/auth/logout_user.dart';

import 'user_home_state.dart';

class UserHomeViewModel {
  final LogoutUser logoutUseCase;

  UserHomeViewModel({
    required this.logoutUseCase,
  });

  final _states = StreamController<UserHomeState>();

  Stream<UserHomeState> get states => _states.stream;

  void logout() {
    logoutUseCase().then((value) => value.fold(onSuccess: _onLogout, onError: _onError));
  }

  _onLoading() {
    _states.sink.add(LoadingState());
  }

  _onLogout(bool data) {
    _states.sink.add((LogoutState()));
  }

  _onError(Failure failure) {
    _states.sink.add((LogoutState()));
  }

  dispose() {
    _states.close();
  }
}
