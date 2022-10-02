abstract class ChangePasswordState {
  ChangePasswordState();
}

class InitialState extends ChangePasswordState {}

class LoadingState extends ChangePasswordState {}

class UpdatePasswordState extends ChangePasswordState {}

class ErrorState extends ChangePasswordState {
  final String message;

  ErrorState({required this.message});
}
