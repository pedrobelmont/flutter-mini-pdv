
import 'package:flutter/material.dart';
import 'package:mini_pdv/providers/cart_provider.dart';
import 'package:mini_pdv/providers/product_provider.dart';
import 'package:mini_pdv/screens/qr_scanner_screen.dart';
import 'package:provider/provider.dart';

void showQuickAddDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Impede que o diálogo feche ao tocar fora
    builder: (BuildContext context) {
      return QuickAddDialog();
    },
  );
}

class QuickAddDialog extends StatefulWidget {
  @override
  _QuickAddDialogState createState() => _QuickAddDialogState();
}

class _QuickAddDialogState extends State<QuickAddDialog> {
  final TextEditingController _controller = TextEditingController();

  void _addProduct(String productId) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final product = productProvider.getProductById(productId);

    if (product != null) {
      cartProvider.add(product);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} adicionado ao carrinho')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produto não encontrado')),
      );
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Adicionar Produto Rápido'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(labelText: 'Código do Produto'),
        onSubmitted: _addProduct,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.qr_code_scanner),
          onPressed: () async {
            final code = await Navigator.push<String>(
              context,
              MaterialPageRoute(builder: (context) => QRScannerScreen()),
            );
            if (code != null) {
              _addProduct(code);
            }
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fecha o diálogo
          },
          child: Text('Finalizar'),
        ),
      ],
    );
  }
}
