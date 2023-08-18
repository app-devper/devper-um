import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/usecases/auth/get_system.dart';
import 'package:um/domain/usecases/auth/keep_alive.dart';
import 'package:um/presentation/core/hook/use_app_config.dart';

Stream<String> useKeepAlive({required Function(bool) onSuccess}) {
  final state = useStreamController<String>();
  final config = useAppConfig();

  keepAlive() async {
    final keepAlive = sl<KeepAlive>();
    final getSystem = sl<GetSystem>();
    final login = await keepAlive();
    if (login.isSuccess) {
      final system = await getSystem();
      if (system.isSuccess) {
        onSuccess(system.value.systemCode == config.system);
      } else {
        state.add(system.error.getMessage());
      }
    } else {
      state.add(login.error.getMessage());
    }
  }

  useEffect(() {
    keepAlive();
    return () {
      state.close();
    };
  }, []);
  return state.stream;
}
