import 'dart:async';

import 'package:common/core/error/failures.dart';
import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/usecases/auth/fetch_token.dart';
import 'package:um/domain/usecases/auth/login_user.dart';

import 'login_state.dart';

class LoginViewModel {
  final LoginUser loginUserUseCase;
  final FetchToken fetchTokenUseCase;

  LoginViewModel({
    required this.loginUserUseCase,
    required this.fetchTokenUseCase,
  });

  final _states = StreamController<LoginState>();

  StreamController<LoginState> get states => _states;

  void login(LoginParam param) {
    _onLoading();
    loginUserUseCase(param).then((value) => {
          value.fold((l) {
            _onError(l);
          }, (r) {
            _onLogged(r);
          })
        });
  }

  void fetchToken() {
    _onLoading();
    fetchTokenUseCase(TokenParams()).then((value) => {
      value.fold((l) {
        _onError(l);
      }, (r) {
        _onLogged(r);
      })
    });
  }

  _onLoading() {
    _states.sink.add(LoadingState());
  }

  _onLogged(Login data) {
    if (!_states.isClosed) {
      _states.sink.add(LoggedState(login: data));
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
