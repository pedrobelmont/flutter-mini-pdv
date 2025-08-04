
import 'package:flutter/material.dart';
import 'package:flutter_pos/models/product_category.dart';
import 'package:flutter_pos/providers/cart_provider.dart';
import 'package:flutter_pos/providers/product_provider.dart';
import 'package:flutter_pos/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final ProductCategory? selectedCategory;

  ProductGrid({this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cart = Provider.of<CartProvider>(context);

    final products = selectedCategory == null
        ? productProvider.products
        : productProvider.products.where((p) => p.category == selectedCategory).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () => cart.add(product),
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Editar'),
                      onTap: () {
                        Navigator.pop(context); // Fecha o bottom sheet
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProductScreen(product: product),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Apagar'),
                      onTap: () {
                        Navigator.pop(context); // Fecha o bottom sheet
                        Provider.of<ProductProvider>(context, listen: false).deleteProduct(product.id);
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(product.name, style: TextStyle(fontSize: 16)),
                SizedBox(height: 5),
                Text('R\$ ${product.price.toStringAsFixed(2)}'),
                Text('Estoque: ${product.stock}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
