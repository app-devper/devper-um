import 'dart:convert';

import 'package:common/core/error/exception.dart';
import 'package:common/core/network/exception.dart';
import 'package:common/core/utils/utils.dart';
import 'package:um/data/datasource/local/local_datasource.dart';
import 'package:um/data/datasource/network/um_service.dart';
import 'package:um/data/datasource/session/app_session.dart';
import 'package:um/data/repositories/login_mapper.dart';
import 'package:um/domain/entities/auth/login.dart';
import 'package:um/domain/entities/auth/param.dart';
import 'package:um/domain/entities/auth/system.dart';
import 'package:um/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final UmService _service;
  final LocalDataSource _localDataSource;
  final AppSessionProvider _appSession;

  LoginRepositoryImpl({
    required UmService service,
    required LocalDataSource localDataSource,
    required AppSessionProvider appSession,
  })  : _localDataSource = localDataSource,
        _service = service,
        _appSession = appSession;

  @override
  Future<Login> loginUser(LoginParam param) async {
    if (param.password.isEmpty || param.username.isEmpty) {
      throw AppException("invalid parameter");
    }
    var mapper = LoginMapper();
    final response = await _service.loginUser(mapper.toLoginRequest(param));
    if (response.isSuccessful) {
      final result = mapper.toLoginDomain(jsonDecode(response.body));
      _localDataSource.cacheToken(result.accessToken);
      _appSession.setAccessToken(result.accessToken);
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<Login> keepAlive() async {
    final accessToken = await _localDataSource.getToken();
    if (accessToken.isEmpty) {
      throw AppException("Please login");
    }
    var mapper = LoginMapper();
    final response = await _service.keepAlive();
    if (response.isSuccessful) {
      final result = mapper.toLoginDomain(jsonDecode(response.body));
      await _localDataSource.cacheToken(result.accessToken);
      _appSession.setAccessToken(result.accessToken);
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<bool> logoutUser() async {
    await _service.logoutUser();
    await _localDataSource.clearToken();
    _appSession.clear();
    return true;
  }

  @override
  Future<String> getRole() async {
    final accessToken = await _localDataSource.getToken();
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
  Future<System> getSystem() async {
    var mapper = LoginMapper();
    final response = await _service.getSystem();
    if (response.isSuccessful) {
      final result = mapper.toSystemDomain(jsonDecode(response.body));
      _appSession.setHostApp(result.host);
      _appSession.setClientId(result.clientId);
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  String getClientId() {
    return _appSession.getClientId();
  }
}
