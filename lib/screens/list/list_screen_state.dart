import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:test_task/core/global_state/global_state.dart';
import 'package:test_task/core/model/errors.dart';
import 'package:test_task/core/model/product.dart';
import 'package:test_task/core/repository/product_repository.dart';

part 'list_screen_state.g.dart';

class ListScreenState = _ListScreenState with _$ListScreenState;

abstract class _ListScreenState with Store {
  _ListScreenState() {
    load();
  }

  @observable
  ObservableList<Product> products = ObservableList();

  final List<Product> _unsortedProducts = [];

  @observable
  bool isOrdered = false;

  @observable
  bool isLoading = true;

  GlobalState get _globalState => GetIt.instance();

  Future<void> load() async {
    isLoading = true;
    final repository = GetIt.instance<ProductRepository>();
    try {
      final result = await repository.fetchProducts();
      _unsortedProducts
        ..clear()
        ..addAll(result);
      products
        ..clear()
        ..addAll(result);
      if (isOrdered) {
        _order();
      }
    } catch (e, trace) {
      GetIt.instance<Logger>().d(e, stackTrace: trace);
      _globalState.setConnectionProblem();
      load();
    } finally {
      isLoading = false;
    }
  }

  void changeOrder() {
    if (isOrdered) {
      products
        ..clear()
        ..addAll(_unsortedProducts);
    } else {
      _order();
    }
    isOrdered = !isOrdered;
  }

  void _order() {
    products.sort((a, b) => a.price.compareTo(b.price));
  }

  Future<bool> remove(Product product) async {
    final repository = GetIt.instance<ProductRepository>();
    try {
      final result = await repository.deleteProduct(product.id);
      if (result) {
        _unsortedProducts.remove(product);
        products.remove(product);
      }
      return result;
    } catch (e, trace) {
      GetIt.instance<Logger>().d(e, stackTrace: trace);
      if (e is UnavailableOffline) {
        final hasToTryAgain = await _globalState.checkBackendAvailability();
        if (hasToTryAgain) {
          return remove(product);
        }
      }
      _globalState.setConnectionProblem();
      return false;
    }
  }
}
