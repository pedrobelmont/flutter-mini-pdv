
import 'package:flutter_pos/models/product.dart';
import 'package:hive_ce/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 2)
class CartItem extends HiveObject {
  @HiveField(0)
  final Product product;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  double discount;

  CartItem({required this.product, this.quantity = 1, this.discount = 0.0});

  double get total => (product.price * quantity) - discount;
}
