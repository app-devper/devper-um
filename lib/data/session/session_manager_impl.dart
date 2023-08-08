import 'package:common/data/session/app_session_provider.dart';
import 'package:um/domain/manager/session_manager.dart';
import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/model/auth/system.dart';

class SessionManagerImpl implements SessionManager {
  final AppSessionProvider _appSession;

  SessionManagerImpl(this._appSession);

  @override
  Future<void> clearAppSession() async {
    _appSession.setAccessToken("");
    _appSession.setHostApp("");
    _appSession.setClientId("");
  }

  @override
  Future<void> setLogin(Login data) async {
    _appSession.setAccessToken(data.accessToken);
  }

  @override
  Future<void> setSystem(System data) async {
    _appSession.setHostApp(data.host);
    _appSession.setClientId(data.clientId);
  }
}
