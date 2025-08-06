import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:test_task/core/global_state/global_state.dart';
import 'package:test_task/core/model/product.dart';
import 'package:test_task/core/repository/product_repository.dart';

part 'list_screen_state.g.dart';

class ListScreenState = _ListScreenState with _$ListScreenState;

abstract class _ListScreenState with Store {
  _ListScreenState() {
    _load();
  }

  @observable
  ObservableList<Product> products = ObservableList();

  @observable
  bool isLoading = true;

  GlobalState get _globalState => GetIt.instance();

  Future<void> _load() async {
    final repository = GetIt.instance<ProductRepository>();
    try {
      final result = await repository.fetchProducts();
      products
        ..clear()
        ..addAll(result);
    } catch (e) {
      _globalState.setError('Loading problem');
    } finally {
      isLoading = false;
    }
  }

  void changeOrder() {
    products.sort((a, b) => a.price.compareTo(b.price));
  }
}
