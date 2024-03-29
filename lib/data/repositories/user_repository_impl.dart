import 'dart:convert';

import 'package:common/core/error/exception.dart';
import 'package:common/core/network/exception.dart';
import 'package:common/core/utils/utils.dart';
import 'package:um/data/datasource/network/um_service.dart';
import 'package:um/data/repositories/user_mapper.dart';
import 'package:um/domain/entities/user/param.dart';
import 'package:um/domain/entities/user/user.dart';
import 'package:um/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UmService _service;

  UserRepositoryImpl({
    required UmService service,
  }) : _service = service;

  @override
  Future<User> getUserInfo() async {
    var mapper = UserMapper();
    final response = await _service.getUserInfo();
    if (response.isSuccessful) {
      final result = mapper.toUserDomain(jsonDecode(response.body));
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<List<User>> getUsers() async {
    var mapper = UserMapper();
    final response = await _service.getUsers();
    if (response.isSuccessful) {
      final result = mapper.toUsersDomain(jsonDecode(response.body));
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<User> getUserById(String userId) async {
    if (userId.isEmpty) {
      throw AppException("Invalid parameter");
    }
    var mapper = UserMapper();
    final response = await _service.getUserById(userId);
    if (response.isSuccessful) {
      final result = mapper.toUserDomain(jsonDecode(response.body));
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<bool> changePassword(ChangePasswordParam param) async {
    if (param.oldPassword.isEmpty || param.newPassword.isEmpty) {
      throw AppException("Invalid parameter");
    }
    var mapper = UserMapper();
    final response = await _service.changePassword(mapper.toChangePasswordRequest(param));
    if (response.isSuccessful) {
      return true;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<User> removeUserById(String userId) async {
    if (userId.isEmpty) {
      throw AppException("Invalid parameter");
    }
    var mapper = UserMapper();
    final response = await _service.removeUserById(userId);
    if (response.isSuccessful) {
      final result = mapper.toUserDomain(jsonDecode(response.body));
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<User> updateRoleById(UpdateRoleParam param) async {
    var mapper = UserMapper();
    final response = await _service.updateRoleById(param.userId, mapper.toUpdateRoleRequest(param.role));
    if (response.isSuccessful) {
      final result = mapper.toUserDomain(jsonDecode(response.body));
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<User> updateStatusById(UpdateStatusParam param) async {
    var mapper = UserMapper();
    final response = await _service.updateStatusById(param.userId, mapper.toUpdateStatusRequest(param.status));
    if (response.isSuccessful) {
      final result = mapper.toUserDomain(jsonDecode(response.body));
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<User> updateUserById(UpdateUserParam param) async {
    if (param.userParam.firstName.isEmpty || param.userParam.lastName.isEmpty) {
      throw AppException("Invalid parameter");
    }
    var mapper = UserMapper();
    final response = await _service.updateUserById(param.userId, mapper.toUpdateUserRequest(param.userParam));
    if (response.isSuccessful) {
      final result = mapper.toUserDomain(jsonDecode(response.body));
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<User> updateUserInfo(UserParam param) async {
    if (param.firstName.isEmpty || param.lastName.isEmpty) {
      throw AppException("Invalid parameter");
    }
    var mapper = UserMapper();
    final response = await _service.updateUserInfo(mapper.toUpdateUserRequest(param));
    if (response.isSuccessful) {
      final result = mapper.toUserDomain(jsonDecode(response.body));
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<User> createUser(CreateParam param) async {
    if (param.password.isEmpty || param.username.isEmpty) {
      throw AppException("Invalid parameter");
    }
    var mapper = UserMapper();
    final response = await _service.createUser(mapper.toCreateUserRequest(param));
    if (response.isSuccessful) {
      final result = mapper.toUserDomain(jsonDecode(response.body));
      return result;
    } else {
      throw HttpException(response);
    }
  }
}
