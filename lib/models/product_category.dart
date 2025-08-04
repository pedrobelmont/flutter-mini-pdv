
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

part 'product_category.g.dart';

@HiveType(typeId: 5)
enum ProductCategory {
  @HiveField(0)
  food,

  @HiveField(1)
  drink,

  @HiveField(2)
  clothing,

  @HiveField(3)
  electronics,

  @HiveField(4)
  it,

  @HiveField(5)
  kitchen,

  @HiveField(6)
  automotive,

  @HiveField(7)
  home,

  @HiveField(8)
  tools,

  @HiveField(9)
  others,
}

extension ProductCategoryExtension on ProductCategory {
  String get name {
    switch (this) {
      case ProductCategory.food:
        return 'Comida';
      case ProductCategory.drink:
        return 'Bebida';
      case ProductCategory.clothing:
        return 'Roupa';
      case ProductCategory.electronics:
        return 'Eletrônicos';
      case ProductCategory.it:
        return 'Informática';
      case ProductCategory.kitchen:
        return 'Cozinha';
      case ProductCategory.automotive:
        return 'Automóvel';
      case ProductCategory.home:
        return 'Casa';
      case ProductCategory.tools:
        return 'Ferramentas';
      case ProductCategory.others:
        return 'Outros';
    }
  }

  IconData get icon {
    switch (this) {
      case ProductCategory.food:
        return Icons.fastfood;
      case ProductCategory.drink:
        return Icons.local_bar;
      case ProductCategory.clothing:
        return Icons.checkroom;
      case ProductCategory.electronics:
        return Icons.devices;
      case ProductCategory.it:
        return Icons.computer;
      case ProductCategory.kitchen:
        return Icons.kitchen;
      case ProductCategory.automotive:
        return Icons.directions_car;
      case ProductCategory.home:
        return Icons.home;
      case ProductCategory.tools:
        return Icons.build;
      case ProductCategory.others:
        return Icons.category;
    }
  }
}
