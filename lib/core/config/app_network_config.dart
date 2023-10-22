import 'package:common/core/network/network_config.dart';
import 'package:flutter/foundation.dart';
import 'package:um/data/datasource/session/app_session.dart';

class AppNetworkConfig extends NetworkConfig {
  final AppSessionProvider _appSession;

  AppNetworkConfig({
    required AppSessionProvider appSession,
  }) : _appSession = appSession;

  @override
  Map<String, String> getHeaders(Uri uri) {
    Map<String, String> headers = {};
    headers["Content-Type"] = "application/json; charset=utf-8";
    if (_appSession.getAccessToken().isNotEmpty) {
      headers["Authorization"] = "Bearer ${_appSession.getAccessToken()}";
    }
    return headers;
  }

  @override
  bool isDebug() {
    return kDebugMode;
  }

}
