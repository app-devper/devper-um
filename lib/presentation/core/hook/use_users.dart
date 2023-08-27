import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/usecases/user/get_users.dart';


Stream<List<User>> useUsers(
  ValueNotifier<UniqueKey> reloadKey,
  StreamController<List<User>> state,
) {
  getUsers() {
    final getUsers = sl<GetUsers>();
    final result = getUsers(Param());
    result.then(
      (value) => {
        value.fold((l) {
          state.addError(l.getMessage());
        }, (r) {
          state.add(r);
        })
      },
    );
  }

  useMemoized(() => getUsers(), [reloadKey.value]);

  return state.stream;
}
