import 'package:um/domain/model/auth/login.dart';
import 'package:um/domain/model/auth/system.dart';

abstract class LoginState {}

class LoadingState extends LoginState {}

class InitState extends LoginState {}

class LoggedState extends LoginState {
  final Login login;

  LoggedState({required this.login});
}

class SystemState extends LoginState {
  final System data;

  SystemState(this.data);
}

class NotLoggedState extends LoginState {}

class ErrorState extends LoginState {
  final String message;

  ErrorState({required this.message});
}
