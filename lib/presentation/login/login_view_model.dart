import 'dart:async';

import 'package:common/app_config.dart';
import 'package:common/core/error/failures.dart';
import 'package:flutter/material.dart';
import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/usecases/auth/fetch_token.dart';
import 'package:um/domain/usecases/auth/login_user.dart';
import 'package:um/core/view_model.dart';

import 'login_state.dart';

class LoginViewModel with ViewModel {
  final TextEditingController usernameEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();

  final FocusNode usernameNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode viewNode = FocusNode();

  final LoginUser loginUserUseCase;
  final FetchToken fetchTokenUseCase;
  final AppConfig config;

  LoginViewModel({
    required this.config,
    required this.loginUserUseCase,
    required this.fetchTokenUseCase,
  });

  final _states = StreamController<LoginState>();

  Stream<LoginState> get states => _states.stream;

  final _init = StreamController<bool>();

  Stream<bool> get initLoading => _init.stream;

  void login() {
    _onLoading();
    loginUserUseCase(_getLoginParam()).then((value) => value.fold(onSuccess: _onLogged, onError: _onError));
  }

  void fetchToken() {
    _onInit();
    fetchTokenUseCase().then((value) => value.fold(onSuccess: _onLogged, onError: _onNotLogged));
  }

  _onInit() {
    _init.sink.add(true);
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
      _states.sink.add(ErrorState(message: failure.getMessage()));
    }
  }

  _onNotLogged(Failure failure) {
    if (!_init.isClosed) {
      _init.sink.add(false);
    }
  }

  _getLoginParam() {
    return LoginParam(
      username: usernameEditingController.text,
      password: passwordEditingController.text,
      system: config.system,
    );
  }

  @override
  dispose() {
    _init.close();
    _states.close();

    usernameNode.dispose();
    passwordNode.dispose();
    viewNode.dispose();

    usernameEditingController.dispose();
    passwordEditingController.dispose();
  }
}
