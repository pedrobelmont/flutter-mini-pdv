import 'package:flutter/material.dart';
import 'package:flutter_pos/enums/hive_boxes.dart';
import 'package:flutter_pos/models/cart_item.dart';
import 'package:flutter_pos/models/product.dart';
import 'package:hive_ce/hive.dart';

class CartProvider with ChangeNotifier {
  final Box<CartItem> _cartBox = Hive.box<CartItem>(HiveBoxes.cart.name);

  List<CartItem> get items => _cartBox.values.toList();

  double get total => items.fold(0.0, (sum, item) => sum + item.total);

  void add(Product product) {
    final existingItem = _cartBox.values.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      existingItem.quantity++;
      _cartBox.put(existingItem.key, existingItem);
    } else {
      _cartBox.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void remove(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
      _cartBox.put(cartItem.key, cartItem);
    } else {
      _cartBox.delete(cartItem.key);
    }
    notifyListeners();
  }

  void removeItemCompletely(CartItem cartItem) {
    _cartBox.delete(cartItem.key);
    notifyListeners();
  }

  void applyDiscount(CartItem cartItem, double discount) {
    cartItem.discount = discount;
    _cartBox.put(cartItem.key, cartItem);
    notifyListeners();
  }

  void applyGlobalDiscount(double discountPercentage) {
    for (var item in items) {
      item.discount =
          item.product.price * item.quantity * (discountPercentage / 100);
      _cartBox.put(item.key, item);
    }
    notifyListeners();
  }

  void clear() {
    _cartBox.deleteAll(this.items.map((item) => item.key).toList());
    notifyListeners();
  }
}
