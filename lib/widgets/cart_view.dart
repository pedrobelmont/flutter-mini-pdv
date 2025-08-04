
import 'package:flutter/material.dart';
import 'package:flutter_pos/dialogs/payment_dialog.dart';
import 'package:flutter_pos/models/payment_method.dart';
import 'package:flutter_pos/providers/cart_provider.dart';
import 'package:flutter_pos/providers/product_provider.dart';
import 'package:flutter_pos/providers/sales_provider.dart';
import 'package:provider/provider.dart';

class CartView extends StatefulWidget {
  

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  void _showPaymentMethodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecione o Método de Pagamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: PaymentMethod.values.map((method) {
              return ListTile(
                title: Text(method.toString().split('.').last),
                onTap: () {
                  final cartProvider = Provider.of<CartProvider>(context, listen: false);
                  final salesProvider = Provider.of<SalesProvider>(context, listen: false);
                  final productProvider = Provider.of<ProductProvider>(context, listen: false);

                  for (var item in cartProvider.items) {
                    productProvider.decrementStock(item.product.id, item.quantity);
                  }

                  salesProvider.addSale(cartProvider.items, cartProvider.total, method);
                  cartProvider.clear();
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final sales = Provider.of<SalesProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[200],
      child: Column(
        children: [

          Text('Carrinho', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return ListTile(
                  title: Text('${item.product.name} x ${item.quantity}'),
                  subtitle: Text('Desconto: R\$ ${item.discount.toStringAsFixed(2)}'),
                  trailing: Text('R\$ ${item.total.toStringAsFixed(2)}'),
                  onTap: () => cart.remove(item),
                  onLongPress: () {
                    cart.removeItemCompletely(item);
                  },
                );
              },
            ),
          ),

          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Total: R\$ ${cart.total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),   
          Row(
            spacing: 22,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          ElevatedButton(
            onPressed: () => showDialog(
            context: context,
            builder: (context) => PaymentDialog(),
          ),
            child: Text('Finalizar Compra'), 
            style: ElevatedButton.styleFrom(
              maximumSize: Size(215, 40),
              shape: LinearBorder(),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  final TextEditingController _discountController = TextEditingController();
                  return AlertDialog(
                    title: Text('Aplicar Desconto Global'),
                    content: TextField(
                      controller: _discountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Percentual de Desconto (%)'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final discountPercentage = double.tryParse(_discountController.text) ?? 0.0;
                          cart.applyGlobalDiscount(discountPercentage);
                          Navigator.pop(context);
                        },
                        child: Text('Aplicar'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Aplicar Desconto Global'),
            style: ElevatedButton.styleFrom(
              maximumSize: Size(215, 40),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: LinearBorder(),
            ),
          ),
      ])
        ],
      ),
    );
  }
}
