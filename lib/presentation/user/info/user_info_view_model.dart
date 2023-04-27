import 'dart:async';
import 'package:common/core/error/failures.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/usecases/user/get_user_info.dart';
import 'package:um/domain/usecases/user/update_user_info.dart';
import 'package:um/presentation/user/info/user_info_state.dart';

class UserInfoViewModel {
  final GetUserInfo getUserInfoUseCase;
  final UpdateUserInfo updateUserInfoUseCase;

  UserInfoViewModel({
    required this.getUserInfoUseCase,
    required this.updateUserInfoUseCase,
  });

  final _states = StreamController<UserInfoState>();

  StreamController<UserInfoState> get states => _states;

  void getUserInfo() {
    getUserInfoUseCase(Param()).then((value) => {
          value.fold((l) {
            _onError(l);
          }, (r) {
            _onGetUser(r);
          })
        });
  }

  void updateUserInfo(UserParam param) {
    _onLoading();
    updateUserInfoUseCase(param)
        .then((value) => {
              value.fold((l) {
                _onError(l);
              }, (r) {
                _onEditUser(r);
              })
            });
  }

  _onLoading() {
    _states.sink.add(LoadingState());
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

  dispose() {
    _states.close();
  }
}
