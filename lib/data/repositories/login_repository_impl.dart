import 'dart:convert';

import 'package:common/core/error/exception.dart';
import 'package:common/core/utils/utils.dart';
import 'package:common/data/local/local_datasource.dart';
import 'package:common/data/network/exception.dart';
import 'package:um/data/datasource/network/um_service.dart';
import 'package:um/data/repositories/login_mapper.dart';
import 'package:um/data/repositories/system_mapper.dart';
import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/model/system/system.dart';
import 'package:um/domain/repositories/login_repository.dart';


class LoginRepositoryImpl implements LoginRepository {
  final UmService service;
  final LocalDataSource localDataSource;

  LoginRepositoryImpl({
    required this.service,
    required this.localDataSource
  });

  @override
  Future<Login> loginUser(LoginParam param) async {
    var mapper = LoginMapper();
    final response = await service.loginUser(mapper.toLoginRequest(param));
    if (response.isSuccessful) {
      final result = mapper.toLoginDomain(jsonDecode(response.body));
      localDataSource.cacheToken(result.accessToken);
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<Login> keepAlive() async {
    var mapper = LoginMapper();
    final response = await service.keepAlive();
    if (response.isSuccessful) {
      final result = mapper.toLoginDomain(jsonDecode(response.body));
      await localDataSource.cacheToken(result.accessToken);
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<bool> logoutUser() async {
    await service.logoutUser();
    await localDataSource.clearToken();
    return true;
  }

  @override
  Future<String> getRole() async {
    final accessToken = await localDataSource.getLastToken();
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
  Future<String> getToken() async{
    final accessToken = await localDataSource.getLastToken();
    if (accessToken.isEmpty) {
      throw AppException("Please login");
    }
    return accessToken;
  }

  @override
  Future<System> getSystem() async {
    var mapper = SystemMapper();
    final response = await service.getSystem();
    if (response.isSuccessful) {
      final result = mapper.toSystemDomain(jsonDecode(response.body));
      return result;
    } else {
      throw HttpException(response);
    }
  }
}
