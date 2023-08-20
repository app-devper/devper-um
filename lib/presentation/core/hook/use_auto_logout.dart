import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/usecases/auth/logout_user.dart';

Stream<bool> useAutoLogout() {
  final state = useStreamController<bool>();

  logoutUser() {
    final logoutUser = sl<LogoutUser>();
    final result = logoutUser();
    result.then((value) => {state.add(true)});
  }

  useEffect(() {
    logoutUser();
    return () {
      state.close();
    };
  }, []);
  return state.stream;
}
