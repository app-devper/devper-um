import 'package:common/core/error/failure.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/entities/auth/system.dart';
import 'package:um/domain/repositories/login_repository.dart';

Future<System> Function() useKeepAlive() {
  Future<System> keepAlive() async {
    final loginRepo = sl<LoginRepository>();
    try {
      final _ = await loginRepo.keepAlive();
      final result = await loginRepo.getSystem();
      return result;
    } on Exception catch (e) {
      return Future.error(toFailure(e));
    }
  }

  final cachedFunction = useCallback(keepAlive, []);
  return cachedFunction;
}
