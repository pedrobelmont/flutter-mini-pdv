import 'package:hive_ce/hive.dart';
import 'package:mini_pdv/models/product_category.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  @HiveField(3)
  int stock;

  @HiveField(4)
  ProductCategory category;

  @HiveField(5)
  String? image;

  Product({required this.id, required this.name, required this.price, this.stock = 0, required this.category, this.image});
}