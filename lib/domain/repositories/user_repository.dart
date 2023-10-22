
import 'package:um/domain/entities/user/param.dart';
import 'package:um/domain/entities/user/user.dart';

abstract class UserRepository {
  Future<User> getUserInfo();

  Future<User> updateUserInfo(UserParam param);

  Future<List<User>> getUsers();

  Future<User> createUser(CreateParam param);

  Future<User> getUserById(String userId);

  Future<User> updateUserById(UpdateUserParam param);

  Future<User> removeUserById(String userId);

  Future<User> updateStatusById(UpdateStatusParam param);

  Future<User> updateRoleById(UpdateRoleParam param);

  Future<bool> changePassword(ChangePasswordParam param);

}
