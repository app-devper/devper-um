abstract class UserHomeState {}

class LoadingState extends UserHomeState {}

class LoggedState extends UserHomeState {
  final bool isAdmin;

  LoggedState(this.isAdmin);
}

class ErrorState extends UserHomeState {
  final String message;

  ErrorState(this.message);
}

class LogoutState extends UserHomeState {}
