
import 'package:hive_ce/hive.dart';
import 'package:mini_pdv/models/cart_item.dart';
import 'package:mini_pdv/models/payment_method.dart';

part 'sale.g.dart';

@HiveType(typeId: 1)
class Sale {
  @HiveField(0)
  final List<CartItem> items;

  @HiveField(1)
  final double total;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final PaymentMethod paymentMethod;

  Sale({required this.items, required this.total, required this.date, required this.paymentMethod});
}
