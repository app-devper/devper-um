import 'dart:async';
import 'package:common/core/error/failures.dart';
import 'package:um/domain/model/auth/param.dart';
import 'package:um/domain/model/auth/system.dart';
import 'package:um/domain/usecases/auth/get_system.dart';
import 'package:um/presentation/landing/landing_state.dart';

class LandingViewModel {
  final GetSystem getSystemUseCase;

  LandingViewModel({
    required this.getSystemUseCase,
  });

  final _states = StreamController<LandingState>();

  StreamController<LandingState> get states => _states;

  void getSystem() {
    getSystemUseCase(SystemParam()).then((value) => {
          value.fold((l) {
            _onError(l);
          }, (r) {
            _onGetSystem(r);
          })
        });
  }

  _onLoading() {
    _states.sink.add(LoadingState());
  }

  _onGetSystem(System data) {
    if (!_states.isClosed) {
      _states.sink.add(SystemState(data));
    }
  }

  _onError(Failure failure) {
    if (!_states.isClosed) {
      _states.sink.add(ErrorState(failure.error));
    }
  }

  dispose() {
    _states.close();
  }
}
