import 'package:common/data/network/network_config.dart';
import 'package:common/data/session/app_session_provider.dart';
import 'package:flutter/foundation.dart';

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

  @override
  String getClientId() {
    return _appSession.getClientId();
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
