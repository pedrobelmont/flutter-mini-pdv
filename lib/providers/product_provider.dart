import 'package:flutter/material.dart';
import 'package:flutter_pos/enums/hive_boxes.dart';
import 'package:flutter_pos/models/product.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

class ProductProvider with ChangeNotifier {
  final Box<Product> _productBox = Hive.box<Product>(HiveBoxes.products.name);
  final Uuid _uuid = Uuid();

  List<Product> get products => _productBox.values.toList();

  void add(Product product) {
    _productBox.put(product.id, product);
    notifyListeners();
  }

  void updateProduct(Product updatedProduct) {
    _productBox.put(updatedProduct.id, updatedProduct);
    notifyListeners();
  }

  void deleteProduct(String productId) {
    _productBox.delete(productId);
    notifyListeners();
  }

  void decrementStock(String productId, int quantity) {
    final product = _productBox.get(productId);
    if (product != null && product.stock >= quantity) {
      product.stock -= quantity;
      _productBox.put(productId, product);
      notifyListeners();
    }
  }

  Product? getProductById(String productId) {
    return _productBox.get(productId);
  }
}