import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:test_task/core/repository/local_repository.dart';
import 'package:test_task/core/repository/network_repository.dart';
import 'package:test_task/core/repository/product_repository.dart';

part 'global_state.g.dart';

class GlobalState extends _GlobalState with _$GlobalState {
  static const errorViewPeriod = 5;
}

abstract class _GlobalState with Store {
  @observable
  String? error;

  bool _hasConnectionProblem = false;
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
      Future.delayed(Duration(seconds: _rnd.nextInt(60))).then((_) {
        checkBackendAvailability();
      });
    }
  }

  Future<void> checkBackendAvailability() async {
    final result = await _networkRepository.checkBackendAvailable();
    if (result) {
      _hasConnectionProblem = false;
      GetIt.instance.unregister<ProductRepository>();
      GetIt.instance.registerSingleton<ProductRepository>(_networkRepository);
    }
  }

  void setError(String err) {
    error = err;
    Future.delayed(Duration(seconds: GlobalState.errorViewPeriod)).then((_) {
      if (error == err) {
        error = null;
      }
    });
  }
}
