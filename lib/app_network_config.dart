import 'package:flutter/foundation.dart';
import 'package:um/data/datasource/session/app_session.dart';

import 'core/config/network_config.dart';

class AppNetworkConfig extends NetworkConfig {
  final AppSession _appSession;

  AppNetworkConfig({
    required AppSession appSession,
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

  @override
  String getHostApp() {
    return _appSession.getHostApp();
  }

  @override
  String getHostUm() {
    return _appSession.getHostUm();
  }
}
