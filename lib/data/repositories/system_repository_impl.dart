import 'dart:convert';

import 'package:common/core/utils/utils.dart';
import 'package:common/data/network/exception.dart';
import 'package:um/data/datasource/network/um_service.dart';
import 'package:um/data/repositories/system_mapper.dart';
import 'package:um/domain/model/system/param.dart';
import 'package:um/domain/model/system/system.dart';
import 'package:um/domain/repositories/system_repository.dart';

class SystemRepositoryImpl implements SystemRepository {
  final UmService service;

  SystemRepositoryImpl({
    required this.service,
  });

  @override
  Future<System> createSystem(CreateParam param) async {
    var mapper = SystemMapper();
    final response = await service.createSystem(mapper.toCreateSystemRequest(param));
    if (response.isSuccessful) {
      final result = mapper.toSystemDomain(jsonDecode(response.body));
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<System> getSystemById(String systemId) async {
    var mapper = SystemMapper();
    final response = await service.getSystemById(systemId);
    if (response.isSuccessful) {
      final result = mapper.toSystemDomain(jsonDecode(response.body));
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<List<System>> getSystems() async {
    var mapper = SystemMapper();
    final response = await service.getSystems();
    if (response.isSuccessful) {
      final result = mapper.toSystemsDomain(jsonDecode(response.body));
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<System> removeSystemById(String systemId) async {
    var mapper = SystemMapper();
    final response = await service.removeSystemById(systemId);
    if (response.isSuccessful) {
      final result = mapper.toSystemDomain(jsonDecode(response.body));
      return result;
    } else {
      throw HttpException(response);
    }
  }

  @override
  Future<System> updateSystemById(UpdateSystemParam param) async {
    var mapper = SystemMapper();
    final response = await service.updateSystemById(param.systemId, mapper.toUpdateSystemRequest(param));
    if (response.isSuccessful) {
      final result = mapper.toSystemDomain(jsonDecode(response.body));
      return result;
    } else {
      throw HttpException(response);
    }
  }
}
