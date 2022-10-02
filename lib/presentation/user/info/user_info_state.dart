

import 'package:um/domain/model/user/user.dart';

abstract class UserInfoState {}

class InitState extends UserInfoState {}

class LoadingState extends UserInfoState {}

class GetUserState extends UserInfoState {
  final User data;

  GetUserState({required this.data});
}

class UpdateUserState extends UserInfoState {
  final User data;

  UpdateUserState({required this.data});
}

class ErrorState extends UserInfoState {
  final String message;

  ErrorState({required this.message});
}
