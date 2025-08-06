import 'package:get_it/get_it.dart';
import 'package:test_task/core/model/errors.dart';
import 'package:test_task/core/model/product.dart';
import 'package:test_task/core/model/product_details.dart';
import 'package:test_task/core/repository/product_repository.dart';
import 'package:test_task/core/storage/sqlite_storage.dart';

class LocalRepository extends ProductRepository {
  SqliteStorage get _storage => GetIt.instance();

  @override
  Future<bool> deleteProduct(int id) {
    throw UnavailableOffline();
  }

  @override
  Future<ProductDetails> fetchProductDetails(int id) {
    throw UnavailableOffline();
  }

  @override
  Future<List<Product>> fetchProducts() => _storage.getProducts();
}
