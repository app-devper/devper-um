import 'dart:convert';

import 'package:um/domain/model/user/param.dart';
import 'package:um/domain/model/user/user.dart';

class UserMapper {
  List<User> toUsersDomain(List json) {
    final users = json.map((data) => toUserDomain(data)).toList();
    return users;
  }

  User toUserDomain(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      username: json['username'],
      status: json['status'],
      role: json['role'],
      phone: json['phone'],
      email: json['email'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
      updatedBy: json['updatedBy'],
      updatedDate: json['updatedDate'],
    );
  }

  toChangePasswordRequest(ChangePasswordParam param) {
    return jsonEncode({
      'oldPassword': param.oldPassword,
      'newPassword': param.newPassword,
    });
  }

  toCreateUserRequest(CreateParam param) {
    return jsonEncode({
      'firstName': param.firstName,
      'lastName': param.lastName,
      'clientId': param.clientId,
      'phone': param.phone,
      'email': param.email,
      'username': param.username,
      'password': param.password,
    });
  }

  toUpdateUserRequest(UserParam param) {
    return jsonEncode({
      'firstName': param.firstName,
      'lastName': param.lastName,
      'phone': param.phone,
      'email': param.email,
    });
  }

  toUpdateStatusRequest(String param) {
    return jsonEncode({
      'status': param,
    });
  }

  toUpdateRoleRequest(String param) {
    return jsonEncode({
      'role': param,
    });
  }


}
