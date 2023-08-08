import 'dart:convert';

import 'package:common/core/error/exception.dart';
import 'package:common/core/utils/utils.dart';
import 'package:common/data/local/local_datasource.dart';
import 'package:common/data/network/exception.dart';
import 'package:um/data/datasource/network/um_service.dart';
import 'package:um/data/repositories/login_mapper.dart';
import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/model/auth/system.dart';
import 'package:um/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final UmService _service;
  final LocalDataSource _localDataSource;

  LoginRepositoryImpl({
    required UmService service,
    required LocalDataSource localDataSource,
  }) : _localDataSource = localDataSource, _service = service;

  @override
  Future<Login> loginUser(LoginParam param) async {
    var mapper = LoginMapper();
    final response = await _service.loginUser(mapper.toLoginRequest(param));
    if (response.isSuccessful) {
      final result = mapper.toLoginDomain(jsonDecode(response.body));
      _localDataSource.cacheToken(result.accessToken);
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<Login> keepAlive(String accessToken) async {
    var mapper = LoginMapper();
    final response = await _service.keepAlive(accessToken);
    if (response.isSuccessful) {
      final result = mapper.toLoginDomain(jsonDecode(response.body));
      await _localDataSource.cacheToken(result.accessToken);
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<bool> logoutUser() async {
    await _service.logoutUser();
    await _localDataSource.clearToken();
    return true;
  }

  @override
  Future<String> getRole() async {
    final accessToken = await _localDataSource.getLastToken();
    final parts = accessToken.split('.');
    if (parts.length != 3) {
      throw AppException('invalid token');
    }
    final payload = Utils.decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw AppException('invalid payload');
    }
    return payloadMap['role'];
  }

  @override
  Future<String> getToken() async {
    final accessToken = await _localDataSource.getLastToken();
    if (accessToken.isEmpty) {
      throw AppException("Please login");
    }
    return accessToken;
  }

  @override
  Future<System> getSystem() async {
    var mapper = LoginMapper();
    final response = await _service.getSystem();
    if (response.isSuccessful) {
      final result = mapper.toSystemDomain(jsonDecode(response.body));
      return result;
    } else {
      throw HttpException(response);
    }
  }
}
