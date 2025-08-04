import 'package:flutter/material.dart';
import 'package:flutter_pos/enums/hive_boxes.dart';
import 'package:flutter_pos/models/cart_item.dart';
import 'package:flutter_pos/models/payment_method.dart';
import 'package:flutter_pos/models/sale.dart';
import 'package:hive_ce/hive.dart';

class SalesProvider with ChangeNotifier {
  final Box<Sale> _salesBox = Hive.box<Sale>(HiveBoxes.sales.name);

  List<Sale> get sales => _salesBox.values.toList();

  void addSale(List<CartItem> items, double total, PaymentMethod paymentMethod) {
    final sale = Sale(
      items: items,
      total: total,
      date: DateTime.now(),
      paymentMethod: paymentMethod,
    );
    _salesBox.add(sale);
    notifyListeners();
  }
}