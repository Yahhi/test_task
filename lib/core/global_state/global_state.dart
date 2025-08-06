import 'dart:async';
import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:test_task/core/repository/local_repository.dart';
import 'package:test_task/core/repository/network_repository.dart';
import 'package:test_task/core/repository/product_repository.dart';

part 'global_state.g.dart';

class GlobalState extends _GlobalState with _$GlobalState {
  static const errorViewPeriod = 10;
}

abstract class _GlobalState with Store {
  @observable
  String? error;

  bool _hasConnectionProblem = false;
  Timer? _networkStateUpdater, _errorHider;
  final _rnd = Random();
  final NetworkRepository _networkRepository = NetworkRepository();

  _GlobalState() {
    GetIt.instance.registerSingleton<ProductRepository>(_networkRepository);
  }

  void setConnectionProblem() {
    setError('Network Problem');
    if (!_hasConnectionProblem) {
      _hasConnectionProblem = true;
      GetIt.instance.unregister<ProductRepository>();
      GetIt.instance.registerSingleton<ProductRepository>(LocalRepository());
      _networkStateUpdater = Timer(Duration(seconds: _rnd.nextInt(60)), () {
        checkBackendAvailability();
      });
    }
  }

  Future<bool> checkBackendAvailability() async {
    final result = await _networkRepository.checkBackendAvailable();
    if (result) {
      _hasConnectionProblem = false;
      GetIt.instance.unregister<ProductRepository>();
      GetIt.instance.registerSingleton<ProductRepository>(_networkRepository);
    }
    return result;
  }

  void setError(String err) {
    error = err;
    _errorHider = Timer(Duration(seconds: GlobalState.errorViewPeriod), () {
      if (error == err) {
        error = null;
      }
    });
  }

  void dispose() {
    _networkStateUpdater?.cancel();
    _errorHider?.cancel();
  }
}
