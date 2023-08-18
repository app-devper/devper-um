import 'dart:async';

import 'package:common/core/error/failures.dart';
import 'package:um/core/view_model/view_model.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/usecases/user/get_users.dart';

import 'users_state.dart';

class UsersViewModel extends ViewModel<UsersState> {
  final GetUsers getUsersUseCase;

  UsersViewModel({
    required this.getUsersUseCase,
  });

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
    emitEvent(LoadingState());
  }

  _onListUser(List<User> data) {
    emitEvent(ListUserState(data: data));
  }

  _onError(Failure failure) {
    emitEvent(ErrorState(message: failure.getMessage()));
  }

  @override
  dispose() {
    super.dispose();
    _users.close();
  }
}
