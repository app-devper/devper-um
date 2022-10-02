class Param {}

class CreateParam {
  final String username;
  final String password;
  final String clientId;
  final String? phone;
  final String? email;
  final String? firstName;
  final String? lastName;

  CreateParam({
    required this.username,
    required this.password,
    required this.clientId,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
  });
}

class UserParam {
  final String firstName;
  final String lastName;
  final String? phone;
  final String? email;

  UserParam({
    required this.firstName,
    required this.lastName,
    this.phone,
    this.email,
  });
}

class UpdateUserParam {
  final String userId;
  final UserParam userParam;

  UpdateUserParam({
    required this.userId,
    required this.userParam,
  });
}

class UpdateStatusParam {
  final String userId;
  final String status;

  UpdateStatusParam({
    required this.userId,
    required this.status,
  });
}

class UpdateRoleParam {
  final String userId;
  final String role;

  UpdateRoleParam({
    required this.userId,
    required this.role,
  });
}

class ChangePasswordParam {
  final String oldPassword;
  final String newPassword;

  ChangePasswordParam({
    required this.oldPassword,
    required this.newPassword,
  });
}
