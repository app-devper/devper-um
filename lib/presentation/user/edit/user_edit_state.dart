
import 'package:um/domain/model/user/user.dart';

abstract class UserEditState {}

class InitState extends UserEditState {}

class LoadingState extends UserEditState {}

class GetUserState extends UserEditState {
  final User data;

  GetUserState({required this.data});
}

class UpdateUserState extends UserEditState {
  final User data;

  UpdateUserState({required this.data});
}

class RemoveUserState extends UserEditState {
  final User data;

  RemoveUserState({required this.data});
}

class ErrorState extends UserEditState {
  final String message;

  ErrorState({required this.message});
}
