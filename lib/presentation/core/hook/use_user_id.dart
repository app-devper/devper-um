import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/usecases/user/get_user_by_id.dart';

Stream<User> useUserId(userId, StreamController<User> state) {
  final state = useStreamController<User>();

  getUserById() {
    final getUserById = sl<GetUserById>();
    final result = getUserById(userId);
    result.then(
      (value) => value.fold((l) {
        state.addError(l.getMessage());
      }, (r) {
        state.add(r);
      }),
    );
  }

  useEffect(() {
    getUserById();
    return () {
    };
  }, [userId]);
  return state.stream;
}
