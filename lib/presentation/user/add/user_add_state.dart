

import 'package:um/domain/model/user/user.dart';

abstract class UserAddState {}

class LoadingState extends UserAddState {}

class CreateUserState extends UserAddState {
  final User data;

  CreateUserState({required this.data});
}

class ErrorState extends UserAddState {
  final String message;

  ErrorState({required this.message});
}
