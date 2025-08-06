import '../model/product.dart';
import '../model/product_details.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
  Future<ProductDetails> fetchProductDetails(int id);
  Future<bool> deleteProduct(int id);
}
