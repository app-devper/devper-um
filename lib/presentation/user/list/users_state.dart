import 'package:um/domain/model/user/user.dart';

abstract class UsersState {}

class LoadingState extends UsersState {}

class ListUserState extends UsersState {
  final List<User> data;

  ListUserState({required this.data});
}

class ErrorState extends UsersState {
  final String message;

  ErrorState({required this.message});
}
