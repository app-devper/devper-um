import 'dart:async';
import 'package:common/core/error/failures.dart';
import 'package:um/core/view_model/view_model.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/usecases/user/get_user_by_id.dart';
import 'package:um/domain/usecases/user/remove_user_by_id.dart';
import 'package:um/domain/usecases/user/update_user_by_id.dart';

import 'user_edit_state.dart';

class UserEditViewModel extends ViewModel {
  final GetUserById getUserByIdUseCase;
  final UpdateUserById updateUserByIdUseCase;
  final RemoveUserById removeUserByIdUseCase;

  UserEditViewModel({
    required this.getUserByIdUseCase,
    required this.updateUserByIdUseCase,
    required this.removeUserByIdUseCase,
  });

  final _states = StreamController<UserEditState>();

  Stream<UserEditState> get states => _states.stream;

  void getUserById(String userId) {
    _onLoading();
    getUserByIdUseCase(userId).then((value) => {
          value.fold((l) {
            _onError(l);
          }, (r) {
            _onGetUser(r);
          })
        });
  }

  void updateUserById(UpdateUserParam param) {
    _onLoading();
    updateUserByIdUseCase(param).then((value) => {
          value.fold((l) {
            _onError(l);
          }, (r) {
            _onEditUser(r);
          })
        });
  }

  void removeUserById(String userId) {
    _onLoading();
    removeUserByIdUseCase(userId).then((value) => {
          value.fold((l) {
            _onError(l);
          }, (r) {
            _onRemoveUser(r);
          })
        });
  }

  _onLoading() {
    _states.sink.add(LoadingState());
  }

  _onRemoveUser(User data) {
    if (!_states.isClosed) {
      _states.sink.add(RemoveUserState(data: data));
    }
  }

  _onGetUser(User data) {
    if (!_states.isClosed) {
      _states.sink.add(GetUserState(data: data));
    }
  }

  _onEditUser(User data) {
    if (!_states.isClosed) {
      _states.sink.add(UpdateUserState(data: data));
    }
  }

  _onError(Failure failure) {
    if (!_states.isClosed) {
      _states.sink.add(ErrorState(message: failure.error));
    }
  }

  @override
  dispose() {
    super.dispose();
    _states.close();
  }
}
