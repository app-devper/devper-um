import 'dart:convert';

import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/model/auth/param.dart';

class LoginMapper {
  String toLoginRequest(LoginParam param) {
    return jsonEncode({
      'username': param.username,
      'password': param.password,
      'system': param.system,
    });
  }

  toLoginDomain(Map<String, dynamic> json) {
    return Login(
      accessToken: json['accessToken']
    );
  }

}
