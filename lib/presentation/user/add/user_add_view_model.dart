import 'dart:async';

import 'package:common/core/error/failures.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/usecases/user/create_user.dart';

import 'user_add_state.dart';

class UserAddViewModel {
  final CreateUser createUserUseCase;

  UserAddViewModel({
    required this.createUserUseCase,
  });

  final _states = StreamController<UserAddState>();

  StreamController<UserAddState> get states => _states;

  void createUser(CreateParam param) {
    _onLoading();
    createUserUseCase(param).then((value) => {
          value.fold((l) {
            _onError(l);
          }, (r) {
            _onCreateUser(r);
          })
        });
  }

  _onLoading() {
    _states.sink.add(LoadingState());
  }

  _onCreateUser(User data) {
    if (!_states.isClosed) {
      _states.sink.add(CreateUserState(data: data));
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
