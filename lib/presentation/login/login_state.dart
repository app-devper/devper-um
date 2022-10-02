import 'package:um/domain/model/auth/login.dart';

abstract class LoginState {}

class LoadingState extends LoginState {}

class LoggedState extends LoginState {
  final Login login;

  LoggedState({required this.login});
}

class ErrorState extends LoginState {
  final String message;

  ErrorState({required this.message});
}
