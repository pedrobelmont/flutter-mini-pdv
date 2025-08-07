
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mini_pdv/models/product_category.dart';
import 'package:mini_pdv/models/product.dart';
import 'package:mini_pdv/providers/product_provider.dart';
import 'package:mini_pdv/screens/add_product_screen.dart';
import 'package:mini_pdv/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProductManagementScreen extends StatefulWidget {
  @override
  _ProductManagementScreenState createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  Future<void> _importCSV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null) return;

    try {
      List<List<dynamic>> fields;

      if (kIsWeb) {
        final bytes = result.files.single.bytes!;
        final csvString = utf8.decode(bytes);
        fields = const CsvToListConverter().convert(csvString);
      } else {
        final filePath = result.files.single.path!;
        final input = File(filePath).openRead();
        fields = await input
            .transform(utf8.decoder)
            .transform(const CsvToListConverter())
            .toList();
      }

      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      // Pula a primeira linha (cabeçalho) e itera sobre o resto
      for (final field in fields.skip(1)) {
        final product = Product(
          id: Uuid().v4(), // Gera um ID único
          name: field[0].toString(),
          price: double.parse(field[1].toString()),
          stock: int.parse(field[2].toString()),
          category: ProductCategory.others, // Categoria padrão
        );
        productProvider.add(product);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produtos importados com sucesso!')),
      );
    } catch (e) {
      print('Erro ao importar CSV: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao importar produtos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Produtos'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final products = productProvider.products;
          if (products.isEmpty) {
            return Center(
              child: Text('Nenhum produto cadastrado.'),
            );
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Text('Preço: R\ ${product.price.toStringAsFixed(2)} | Estoque: ${product.stock}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProductScreen(product: product),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          productProvider.deleteProduct(product.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Produto excluído com sucesso!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _importCSV,
            child: Icon(Icons.upload_file),
            heroTag: 'import_csv',
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductScreen()),
              );
            },
            child: Icon(Icons.add),
            heroTag: 'add_product',
          ),
        ],
      ),
    );
  }
}
