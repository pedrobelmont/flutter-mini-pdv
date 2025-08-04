import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos/models/payment_method.dart';
import 'package:flutter_pos/providers/cart_provider.dart';
import 'package:flutter_pos/providers/sales_provider.dart';
import 'package:provider/provider.dart';

class PaymentDialog extends StatefulWidget {
  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  PaymentMethod? _selectedPaymentMethod;
  double _amountToPay = 0.0;
  late double _total;
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    _total = cartProvider.total;
    _amountToPay = _total;
    _textController.text = _amountToPay.toStringAsFixed(2);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onPaymentMethodSelected(PaymentMethod method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  void _processPayment() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final salesProvider = Provider.of<SalesProvider>(context, listen: false);
    final paidAmount = double.tryParse(_textController.text) ?? 0.0;

    if (paidAmount <= 0 || _selectedPaymentMethod == null) return;

    if (paidAmount < _total) {
      salesProvider.addSale(cartProvider.items, paidAmount, _selectedPaymentMethod!);
      setState(() {
        _total -= paidAmount;
        _amountToPay = _total;
        _textController.text = _amountToPay.toStringAsFixed(2);
        _selectedPaymentMethod = null;
      });
    } else {
      salesProvider.addSale(cartProvider.items, _total, _selectedPaymentMethod!);
      cartProvider.clear();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.digit1) {
            _onPaymentMethodSelected(PaymentMethod.dinheiro);
          } else if (event.logicalKey == LogicalKeyboardKey.digit2) {
            _onPaymentMethodSelected(PaymentMethod.credito);
          } else if (event.logicalKey == LogicalKeyboardKey.digit3) {
            _onPaymentMethodSelected(PaymentMethod.debito);
          } else if (event.logicalKey == LogicalKeyboardKey.digit4) {
            _onPaymentMethodSelected(PaymentMethod.pix);
          } else if (event.logicalKey == LogicalKeyboardKey.enter) {
            _processPayment();
          }
        }
      },
      child: AlertDialog(
        title: Text('Pagamento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total: R\$ ${_total.toStringAsFixed(2)} '),
            SizedBox(height: 20),
            TextField(
              controller: _textController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor a pagar',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPaymentMethodButton(PaymentMethod.dinheiro, 'Dinheiro (1)'),
                _buildPaymentMethodButton(PaymentMethod.credito, 'Crédito (2)'),
                _buildPaymentMethodButton(PaymentMethod.debito, 'Débito (3)'),
                _buildPaymentMethodButton(PaymentMethod.pix, 'Pix (4)'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _selectedPaymentMethod != null ? _processPayment : null,
            child: Text('Finalizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodButton(PaymentMethod method, String text) {
    final isSelected = _selectedPaymentMethod == method;
    return ElevatedButton(
      onPressed: () => _onPaymentMethodSelected(method),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Theme.of(context).primaryColor : null,
      ),
      child: Text(text),
    );
  }
}
