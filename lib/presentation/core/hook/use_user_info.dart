import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/usecases/user/get_user_info.dart';

Stream<User> useUserInfo(StreamController<User> state) {

  getUserInfo() {
    final getUserInfo = sl<GetUserInfo>();
    final result = getUserInfo(Param());
    result.then(
      (value) => value.fold((l) {
        state.addError(l.getMessage());
      }, (r) {
        state.add(r);
      }),
    );
  }

  useEffect(() {
    getUserInfo();
    return () {
    };
  }, []);
  return state.stream;
}
