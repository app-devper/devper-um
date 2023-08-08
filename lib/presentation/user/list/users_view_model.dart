import 'dart:async';

import 'package:common/core/error/failures.dart';
import 'package:um/core/view_model/view_model.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/usecases/user/get_users.dart';

import 'users_state.dart';

class UsersViewModel extends ViewModel {
  final GetUsers getUsersUseCase;

  UsersViewModel({
    required this.getUsersUseCase,
  });

  final _states = StreamController<UsersState>();

  Stream<UsersState> get states => _states.stream;

  final _users = StreamController<List<User>>();

  Stream<List<User>> get users => _users.stream;

  getUsers() {
    _onLoading();
    getUsersUseCase(Param()).then((value) => {
          value.fold((l) {
            _onError(l);
          }, (r) {
            _onListUser(r);
          })
        });
  }

  setUsers(List<User> data) {
    if (!_users.isClosed) {
      _users.sink.add(data);
    }
  }

  _onLoading() {
    if (!_states.isClosed) {
      _states.sink.add(LoadingState());
    }
  }

  _onListUser(List<User> data) {
    if (!_states.isClosed) {
      _states.sink.add(ListUserState(data: data));
    }
  }

  _onError(Failure failure) {
    if (!_states.isClosed) {
      _states.sink.add(ErrorState(message: failure.getMessage()));
    }
  }

  @override
  dispose() {
    super.dispose();
    _states.close();
    _users.close();
  }
}
