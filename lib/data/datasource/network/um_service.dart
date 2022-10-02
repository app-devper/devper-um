import 'package:common/data/network/custom_client.dart';
import 'package:http/http.dart' as http;
import 'package:common/data/network/network_config.dart';

class UmService {
  final NetworkConfig networkConfig;
  final CustomClient client;

  UmService({
    required this.networkConfig,
    required this.client,
  });

  // Auth
  Future<http.Response> loginUser(String jsonBody) {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/auth/login');
    return client.post(url, headers: networkConfig.getHeaders(url), body: jsonBody);
  }

  Future<http.Response> logoutUser() {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/auth/logout');
    return client.post(url, headers: networkConfig.getHeaders(url));
  }

  Future<http.Response> keepAlive() {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/auth/keep-alive');
    return client.get(url, headers: networkConfig.getHeaders(url));
  }

  Future<http.Response> getSystem() {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/auth/system');
    return client.get(url, headers: networkConfig.getHeaders(url));
  }

  // User
  Future<http.Response> getUserInfo() {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/user/info');
    return client.get(url, headers: networkConfig.getHeaders(url));
  }

  Future<http.Response> updateUserInfo(String jsonBody) {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/user/info');
    return client.put(url, headers: networkConfig.getHeaders(url), body: jsonBody);
  }

  Future<http.Response> changePassword(String jsonBody) {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/user/change-password');
    return client.put(url, headers: networkConfig.getHeaders(url), body: jsonBody);
  }

  // Admin
  Future<http.Response> getUsers() {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/admin/user');
    return client.get(url, headers: networkConfig.getHeaders(url));
  }

  Future<http.Response> getUserById(String userId) {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/admin/user/$userId');
    return client.get(url, headers: networkConfig.getHeaders(url));
  }

  Future<http.Response> updateUserById(String userId, String jsonBody) {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/admin/user/$userId');
    return client.put(url, headers: networkConfig.getHeaders(url), body: jsonBody);
  }

  Future<http.Response> removeUserById(String userId) {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/admin/user/$userId');
    return client.delete(url, headers: networkConfig.getHeaders(url));
  }

  Future<http.Response> createUser(String jsonBody) {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/admin/user');
    return client.post(url, headers: networkConfig.getHeaders(url), body: jsonBody);
  }

  Future<http.Response> updateStatusById(String userId, String jsonBody) {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/admin/user/$userId/status');
    return client.patch(url, headers: networkConfig.getHeaders(url), body: jsonBody);
  }

  Future<http.Response> updateRoleById(String userId, String jsonBody) {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/admin/user/$userId/role');
    return client.patch(url, headers: networkConfig.getHeaders(url), body: jsonBody);
  }

  // System
  Future<http.Response> getSystems() {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/system');
    return client.get(url, headers: networkConfig.getHeaders(url));
  }

  Future<http.Response> createSystem(String jsonBody) {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/system');
    return client.post(url, headers: networkConfig.getHeaders(url), body: jsonBody);
  }

  Future<http.Response> getSystemById(String systemId) {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/system/$systemId');
    return client.get(url, headers: networkConfig.getHeaders(url));
  }

  Future<http.Response> updateSystemById(String systemId, String jsonBody) {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/system/$systemId');
    return client.put(url, headers: networkConfig.getHeaders(url), body: jsonBody);
  }

  Future<http.Response> removeSystemById(String systemId) {
    var url = Uri.parse('${networkConfig.getHostUm()}/api/um/v1/system/$systemId');
    return client.delete(url, headers: networkConfig.getHeaders(url));
  }

}
