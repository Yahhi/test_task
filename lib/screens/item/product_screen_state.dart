import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:test_task/core/global_state/global_state.dart';
import 'package:test_task/core/model/errors.dart';
import 'package:test_task/core/model/product.dart';
import 'package:test_task/core/model/product_details.dart';
import 'package:test_task/core/repository/product_repository.dart';

part 'product_screen_state.g.dart';

class ProductScreenState = _ProductScreenState with _$ProductScreenState;

abstract class _ProductScreenState with Store {
  final Product product;

  @observable
  ProductDetails? details;

  GlobalState get _globalState => GetIt.instance();

  _ProductScreenState(this.product) {
    _load();
  }

  ProductRepository get _repository => GetIt.instance();

  Future<void> _load() async {
    try {
      details = await _repository.fetchProductDetails(product.id);
    } catch (e, trace) {
      GetIt.instance<Logger>().e(e, stackTrace: trace);
      if (e is UnavailableOffline) {
        final hasToTryAgain = await _globalState.checkBackendAvailability();
        if (hasToTryAgain) {
          _load();
        }
      } else {
        _globalState.setConnectionProblem();
      }
    }
  }
}
