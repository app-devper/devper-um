import 'package:common/data/network/network_config.dart';
import 'package:common/data/session/app_session_provider.dart';
import 'package:flutter/foundation.dart';

class AppNetworkConfig extends NetworkConfig {
  final AppSessionProvider appSession;

  AppNetworkConfig({required this.appSession});

  @override
  Map<String, String> getHeaders(Uri uri) {
    Map<String, String> headers = {};
    headers["Content-Type"] = "application/json; charset=utf-8";
    if (appSession.getAccessToken().isNotEmpty) {
      headers["Authorization"] = "Bearer ${appSession.getAccessToken()}";
    }
    return headers;
  }

  @override
  bool isDebug() {
    return kDebugMode;
  }

  @override
  String getClientId() {
    return appSession.getClientId();
  }

  @override
  String getHostApp() {
    return appSession.getHostApp();
  }

  @override
  String getHostUm() {
    return appSession.getHostUm();
  }
}
