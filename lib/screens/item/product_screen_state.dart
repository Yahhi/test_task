import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:test_task/core/model/product.dart';
import 'package:test_task/core/model/product_details.dart';
import 'package:test_task/core/repository/product_repository.dart';

part 'product_screen_state.g.dart';

class ProductScreenState = _ProductScreenState with _$ProductScreenState;

abstract class _ProductScreenState with Store {
  final Product product;

  @observable
  ProductDetails? details;

  _ProductScreenState(this.product) {
    _load();
  }

  ProductRepository get _repository => GetIt.instance();

  Future<void> _load() async {
    details = await _repository.fetchProductDetails(product.id);
  }
}
