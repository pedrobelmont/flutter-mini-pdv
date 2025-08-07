import 'package:flutter/material.dart';
import 'package:mini_pdv/enums/hive_boxes.dart';
import 'package:mini_pdv/models/cart_item.dart';
import 'package:mini_pdv/models/payment_method.dart';
import 'package:mini_pdv/models/sale.dart';
import 'package:mini_pdv/providers/product_provider.dart';
import 'package:hive_ce/hive.dart';

class SalesProvider with ChangeNotifier {
  final Box<Sale> _salesBox = Hive.box<Sale>(HiveBoxes.sales.name);

  List<Sale> get sales => _salesBox.values.toList();

  void addSale(List<CartItem> items, double total, PaymentMethod paymentMethod,
      ProductProvider productProvider) {
    final sale = Sale(
      items: items,
      total: total,
      date: DateTime.now(),
      paymentMethod: paymentMethod,
    );
    _salesBox.add(sale);

    for (final item in items) {
      productProvider.decrementStock(item.product.id, item.quantity);
    }

    notifyListeners();
  }
}