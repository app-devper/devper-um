import 'dart:async';
import 'package:common/core/error/failures.dart';
import 'package:um/core/view_model.dart';
import 'package:um/domain/usecases/auth/logout_user.dart';

import 'error_state.dart';

class ErrorViewModel with ViewModel {
  final LogoutUser logoutUseCase;

  ErrorViewModel({
    required this.logoutUseCase,
  });

  final _states = StreamController<ErrorState>();

  Stream<ErrorState> get states => _states.stream;

  void logout() {
    _onLoading();
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

  @override
  dispose() {
    _states.close();
  }
}
