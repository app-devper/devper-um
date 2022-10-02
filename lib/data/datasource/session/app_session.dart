
import 'package:common/app_config.dart';
import 'package:common/data/session/app_session_provider.dart';

class AppSession extends AppSessionProvider {
  String _hostUm = "";
  String _hostApp = "";
  String _clientId = "";
  String _accessToken = "";
  String _locale = "th";

  AppSession(AppConfig config){
    _hostUm = config.apiUrl;
  }

  @override
  String getLocale() {
    return _locale;
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
  void setHostUm(String hostUm) {
    _hostUm = hostUm;
  }

  @override
  void setLocale(String locale) {
    _locale = locale;
  }

}
