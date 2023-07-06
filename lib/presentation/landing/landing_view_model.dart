import 'dart:async';
import 'package:common/app_config.dart';
import 'package:common/core/error/failures.dart';
import 'package:um/core/view_model.dart';
import 'package:um/domain/model/auth/system.dart';
import 'package:um/domain/usecases/auth/get_system.dart';

import 'landing_state.dart';

class LandingViewModel with ViewModel {
  final GetSystem getSystemUseCase;
  final AppConfig config;

  LandingViewModel({
    required this.config,
    required this.getSystemUseCase,
  });

  final _states = StreamController<LandingState>();

  Stream<LandingState> get states => _states.stream;

  void getSystem() {
    _onLoading();
    getSystemUseCase().then((value) => value.fold(onSuccess: _onSystem, onError: _onError));
  }

  _onLoading() {
    _states.sink.add(LoadingState());
  }

  _onSystem(System data) {
    if (!_states.isClosed) {
      _states.sink.add(SystemState(data));
    }
  }

  _onError(Failure failure) {
    if (!_states.isClosed) {
      _states.sink.add(ErrorState(failure.error));
    }
  }

  @override
  dispose() {
    _states.close();
  }
}
