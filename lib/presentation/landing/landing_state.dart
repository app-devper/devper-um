import 'package:um/domain/model/system/system.dart';

abstract class LandingState {}

class LoadingState extends LandingState {}

class SystemState extends LandingState {
  final System data;

  SystemState(this.data);
}

class ErrorState extends LandingState {
  final String message;

  ErrorState(this.message);
}
