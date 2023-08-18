import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:um/container.dart';
import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';
import 'package:um/domain/usecases/user/get_users.dart';

Stream<List<User>> useUsers() {
  final state = useStreamController<List<User>>();

  getUser() {
    final getUsers = sl<GetUsers>();
    final promise = getUsers(Param());
    promise.then(
      (value) => {
        value.fold((l) {
          state.addError(l.getMessage());
        }, (r) {
          state.add(r);
        })
      },
    );
  }

  useEffect(() {
    getUser();
    return () {
      state.close();
    };
  }, []);
  return state.stream;
}
