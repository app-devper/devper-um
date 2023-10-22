import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/repositories/login_repository.dart';

String useClientId() {
  getClientId() {
    final loginRepo = sl<LoginRepository>();
    return loginRepo.getClientId();
  }

  final data = useMemoized(getClientId, []);
  return data;
}
