import 'dart:async';

import 'package:common/core/error/failures.dart';
import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/usecases/auth/fetch_token.dart';
import 'package:um/domain/usecases/auth/login_user.dart';
import 'package:um/core/view_model.dart';
import 'package:um/presentation/login/login_state.dart';

class LoginViewModel with ViewModel {
  final LoginUser loginUserUseCase;
  final FetchToken fetchTokenUseCase;

  LoginViewModel({
    required this.loginUserUseCase,
    required this.fetchTokenUseCase,
  });

  final _states = StreamController<LoginState>();

  Stream<LoginState> get states => _states.stream;

  final _init = StreamController<bool>();

  Stream<bool> get initLoading => _init.stream;

  void login(LoginParam param) {
    _onLoading();
    loginUserUseCase(param).then((value) => {value.fold(onSuccess: _onLogged, onError: _onError)});
  }

  void fetchToken() {
    _onInit();
    fetchTokenUseCase().then((value) => {value.fold(onSuccess: _onLogged, onError: _onNotLogged)});
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
      _states.sink.add(ErrorState(message: failure.error));
    }
  }

  _onNotLogged(Failure failure) {
    if (!_init.isClosed) {
      _init.sink.add(false);
    }
  }

  @override
  dispose() {
    _init.close();
    _states.close();
  }
}
