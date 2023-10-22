import 'package:common/config/app_config.dart';

abstract class AppSessionProvider {

  String getClientId();

  void setClientId(String clientId);

  String getHostApp();

  void setHostApp(String hostApp);

  String getHostUm();

  String getAccessToken();

  void setAccessToken(String accessToken);

  void clear();
}

class AppSession extends AppSessionProvider {
  String _hostUm = "";
  String _hostApp = "";
  String _clientId = "";
  String _accessToken = "";

  AppSession(AppConfig config) {
    _hostUm = config.apiUrl;
  }

  @override
  String getClientId() {
    return _clientId;
  }

  @override
  String getHostApp() {
    return _hostApp;
  }

  @override
  String getAccessToken() {
    return _accessToken;
  }

  @override
  void setAccessToken(String accessToken) {
    _accessToken = accessToken;
  }

  @override
  String getHostUm() {
    return _hostUm;
  }

  @override
  void setClientId(String clientId) {
    _clientId = clientId;
  }

  @override
  void setHostApp(String hostApp) {
    _hostApp = hostApp;
  }

  @override
  void clear() {
    _hostApp = "";
    _clientId = "";
    _accessToken = "";
  }
}
