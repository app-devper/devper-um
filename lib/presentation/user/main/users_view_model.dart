import 'dart:async';

import 'package:common/core/error/failures.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/usecases/user/get_users.dart';

import 'users_state.dart';

class UsersViewModel {
  final GetUsers getUsersUseCase;

  UsersViewModel({
    required this.getUsersUseCase,
  });

  final _states = StreamController<UsersState>();

  StreamController<UsersState> get states => _states;

  final _users = StreamController<List<User>>();

  StreamController<List<User>> get users => _users;

  void getUsers() {
    getUsersUseCase(Param()).then((value) => {
          value.fold((l) {
            _onError(l);
          }, (r) {
            _onListUser(r);
          })
        });
  }

  void setUsers(List<User> data) {
    _users.sink.add(data);
  }

  _onLoading() {
    _states.sink.add(LoadingState());
  }

  _onListUser(List<User> data) {
    if (!_states.isClosed) {
      _states.sink.add(ListUserState(data: data));
    }
  }

  _onUpdateUser(User data) {
    if (!_states.isClosed) {
      _states.sink.add((UpdateUserState(data: data)));
    }
  }

  _onError(Failure failure) {
    if (!_states.isClosed) {
      _states.sink.add(ErrorState(message: failure.error));
    }
  }

  dispose() {
    _states.close();
    _users.close();
  }
}
