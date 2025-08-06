// lib/services/network_repository.dart
import 'dart:async';
import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:test_task/core/storage/sqlite_storage.dart';

import '../model/product_details.dart';
import 'product_repository.dart';
import '../model/product.dart';

class NetworkRepository extends ProductRepository {
  static const String baseUrl = 'https://api.fake-rest.refine.dev'; // Replace with backend URL
  static const String _products = 'products';
  static const String _details = 'product-detail';

  SqliteStorage get _storage => GetIt.instance();

  @override
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/$_products'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      final products = body.map((json) => Product.fromJson(json)).toList();
      unawaited(_storage.insertProducts(products));
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<ProductDetails> fetchProductDetails(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$_details/$id'));
    if (response.statusCode == 200) {
      return ProductDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product details');
    }
  }

  @override
  Future<bool> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$_products/$id'));
    if (response.statusCode == 200) {
      _storage.deleteProductById(id);
      return true;
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Future<bool> checkBackendAvailable() async {
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 5));

      // Any 2xx status means API is available
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      }
      return false;
    } catch (_) {
      return false; // Timeout or network error
    }
  }
}
