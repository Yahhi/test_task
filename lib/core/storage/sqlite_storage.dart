import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/product.dart';

class SqliteStorage {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('products.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        material TEXT,
        categoryId INTEGER
      )
    ''');
  }

  Future<void> insertProducts(List<Product> products) async {
    final db = await database;

    // Run all inserts in a single transaction for efficiency
    await db.transaction((txn) async {
      final batch = txn.batch();

      for (var product in products) {
        batch.insert('products', {
          'id': product.id,
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'material': product.material,
          'categoryId': product.category.id,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit(noResult: true); // NoResult improves speed
    });
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final result = await db.query('products');

    return result.map((json) {
      return Product(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        price: json['price'] as double,
        material: json['material'] as String,
        category: Category(id: json['categoryId'] as int),
      );
    }).toList();
  }

  Future<Product?> getProductById(int id) async {
    final db = await database;
    final result = await db.query('products', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      final json = result.first;
      return Product(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        price: json['price'] as double,
        material: json['material'] as String,
        category: Category(id: json['categoryId'] as int),
      );
    }
    return null;
  }

  Future<int> deleteProductById(int id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
