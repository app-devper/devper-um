import 'dart:async';

import 'package:common/core/error/failure.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/entities/user/user.dart';
import 'package:um/domain/repositories/user_repository.dart';

Future<User> useUserInfo() {
  Future<User> getUserInfo() async {
    final userRepo = sl<UserRepository>();
    try {
      final result = await userRepo.getUserInfo();
      return result;
    } on Exception catch (e) {
      return Future.error(toFailure(e));
    }
  }

  final data = useMemoized(getUserInfo, []);
  return data;
}
