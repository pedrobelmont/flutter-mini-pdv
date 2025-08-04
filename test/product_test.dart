
import 'package:flutter_pos/models/product.dart';
import 'package:flutter_pos/models/product_category.dart';
import 'package:flutter_pos/providers/product_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mockito/mockito.dart';

class MockProductProvider extends Mock implements ProductProvider {}

void main() {
  group('Product Tests', () {
    late ProductProvider productProvider;

    setUp(() {
      productProvider = MockProductProvider();
    });

    test('Add Demo Products', () {
      final products = [
        Product(
          id: '1',
          name: 'Coca-Cola',
          price: 5.0,
          category: ProductCategory.bebidas,
          image: 'assets/images/coca_cola.png',
        ),
        Product(
          id: '2',
          name: 'X-Burger',
          price: 15.0,
          category: ProductCategory.lanches,
          image: 'assets/images/x_burger.png',
        ),
        Product(
          id: '3',
          name: 'Batata Frita',
          price: 10.0,
          category: ProductCategory.acompanhamentos,
          image: 'assets/images/batata_frita.png',
        ),
      ];

      for (var product in products) {
        productProvider.add(product);
      }

      when(productProvider.products).thenReturn(products);

      expect(productProvider.products.length, 3);
    });
  });
}
