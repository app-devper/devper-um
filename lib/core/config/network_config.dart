abstract class NetworkConfig {
  Map<String, String> getHeaders(Uri uri);

  bool isDebug();

  String getHostApp();

  String getHostUm();
}
