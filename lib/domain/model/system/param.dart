class Param {}

class CreateParam {
  final String clientId;
  final String systemName;
  final String systemCode;
  final String host;

  CreateParam({
    required this.clientId,
    required this.systemName,
    required this.systemCode,
    required this.host,
  });
}

class UpdateSystemParam {
  final String systemId;
  final String systemName;
  final String host;

  UpdateSystemParam({
    required this.systemId,
    required this.systemName,
    required this.host,
  });
}
