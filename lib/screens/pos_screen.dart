import 'package:flutter/material.dart';
import 'package:flutter_pos/dialogs/payment_dialog.dart';
import 'package:flutter_pos/dialogs/quick_add_dialog.dart';
import 'package:flutter_pos/models/payment_method.dart';
import 'package:flutter_pos/models/product_category.dart';
import 'package:flutter_pos/providers/cart_provider.dart';
import 'package:flutter_pos/providers/company_info_provider.dart';
import 'package:flutter_pos/providers/sales_provider.dart';
import 'package:flutter_pos/screens/add_product_screen.dart';
import 'package:flutter_pos/screens/sales_history_screen.dart';
import 'package:flutter_pos/widgets/cart_view.dart';
import 'package:flutter_pos/widgets/product_grid.dart';
import 'package:provider/provider.dart';

class PosScreen extends StatefulWidget {
  final String employeeName;

  PosScreen({required this.employeeName});

  @override
  _PosScreenState createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  ProductCategory? _selectedCategory;

  

  @override
  Widget build(BuildContext context) {
    final companyInfo = Provider.of<CompanyInfoProvider>(context).companyInfo;
    final companyName = companyInfo?.name ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('$companyName - ${widget.employeeName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SalesHistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ProductCategory.values.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  final isSelected = _selectedCategory == null;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChoiceChip(
                      label: Text('Todos'),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = null;
                        });
                      },
                    ),
                  );
                }
                final category = ProductCategory.values[index - 1];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChoiceChip(
                    avatar: Icon(category.icon, color: isSelected ? Colors.white : Colors.black),
                    label: Text(category.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : null;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ProductGrid(selectedCategory: _selectedCategory),
                ),
                Expanded(
                  flex: 1,
                  child: CartView(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         
        },
        child: Icon(Icons.payment),
      ),
    );
  }
}