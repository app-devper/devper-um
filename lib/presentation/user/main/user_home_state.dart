abstract class UserHomeState {}

class LoadingState extends UserHomeState {}

class ErrorState extends UserHomeState {
  final String message;

  ErrorState(this.message);
}

class LogoutState extends UserHomeState {}
