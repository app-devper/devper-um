import 'dart:convert';

import 'package:um/domain/entities/auth/login.dart';
import 'package:um/domain/entities/auth/param.dart';
import 'package:um/domain/entities/auth/system.dart';

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

  System toSystemDomain(Map<String, dynamic> json) {
    return System(
        id: json['id'],
        clientId: json['clientId'],
        systemName: json['systemName'],
        systemCode: json['systemCode'],
        host: json['host']
    );
  }

}
