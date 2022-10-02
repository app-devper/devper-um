class User {
  final String id;
  final String? firstName;
  final String? lastName;
  final String username;
  final String role;
  final String status;
  final String? phone;
  final String? email;
  final String createdBy;
  final String createdDate;
  final String updatedBy;
  final String updatedDate;

  User({
    required this.id,
    this.firstName,
    this.lastName,
    required this.username,
    required this.role,
    required this.status,
    this.phone,
    this.email,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });
}
