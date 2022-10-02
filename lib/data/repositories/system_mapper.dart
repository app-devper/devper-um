import 'dart:convert';

import 'package:um/domain/model/system/param.dart';
import 'package:um/domain/model/system/system.dart';

class SystemMapper {

  List<System> toSystemsDomain(List json) {
    final list = json.map((data) => toSystemDomain(data)).toList();
    return list;
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

  toCreateSystemRequest(CreateParam param) {
    return jsonEncode({
      'systemName': param.systemName,
      'systemCode': param.systemCode,
      'clientId': param.clientId,
      'host': param.host,
    });
  }

  toUpdateSystemRequest(UpdateSystemParam param) {
    return jsonEncode({
      'systemName': param.systemName,
      'host': param.host,
    });
  }
}
