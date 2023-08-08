import 'dart:async';

import 'package:common/app_config.dart';
import 'package:common/core/error/failures.dart';
import 'package:um/core/view_model/view_model.dart';
import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/model/auth/system.dart';
import 'package:um/domain/usecases/auth/keep_alive.dart';
import 'package:um/domain/usecases/auth/get_system.dart';
import 'package:um/domain/usecases/auth/login_user.dart';

import 'login_state.dart';

class LoginViewModel extends ViewModel {
  final AppConfig _config;
  final LoginUser _loginUser;
  final KeepAlive _keepAlive;
  final GetSystem _getSystem;

  LoginViewModel(
    this._config,
    this._loginUser,
    this._keepAlive,
    this._getSystem,
  );

  final _states = StreamController<LoginState>();

  Stream<LoginState> get states => _states.stream;

  final _init = StreamController<Failure>();

  Stream<Failure> get init => _init.stream;

  AppConfig get config => _config;

  login(LoginParam param) {
    _onLoading();
    _loginUser(param).then((value) => value.fold(onSuccess: _onLogged, onError: _onError));
  }

  keepAlive() {
    _keepAlive().then((value) => value.fold(onSuccess: _onLogged, onError: _onNotLogged));
  }

  getSystem() {
    _getSystem().then((value) => value.fold(onSuccess: _onSystem, onError: _onError));
  }

  _onLoading() {
    if (!_states.isClosed) {
      _states.sink.add(LoadingState());
    }
  }

  _onLogged(Login data) {
    if (!_states.isClosed) {
      _states.sink.add(LoggedState(login: data));
    }
  }

  _onError(Failure failure) {
    if (!_states.isClosed) {
      _states.sink.add(ErrorState(message: failure.getMessage()));
    }
  }

  _onNotLogged(Failure failure) {
    if (!_init.isClosed) {
      _init.sink.add(failure);
    }
  }

  _onSystem(System data) {
    if (!_states.isClosed) {
      _states.sink.add(SystemState(data));
    }
  }


  @override
  dispose() {
    super.dispose();
    _init.close();
    _states.close();
  }
}
