import 'package:common/core/error/failures.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/model/auth/system.dart';
import 'package:um/domain/usecases/auth/keep_alive.dart';

Stream<String> useKeepAlive({required Function(System) onSuccess}) {
  final state = useStreamController<String>();

  success(System system) {
    onSuccess(system);
  }

  error(Failure failure) {
    state.add(failure.getMessage());
  }

  keepAlive() {
    final keepAlive = sl<KeepAlive>();
    final result = keepAlive();
    result.then((value) => value.fold(onSuccess: success, onError: error));
  }

  useEffect(() {
    keepAlive();
    return () {
      state.close();
    };
  }, []);
  return state.stream;
}
