
import 'package:flutter/material.dart';
import 'package:mini_pdv/models/product.dart';
import 'package:mini_pdv/models/product_category.dart';
import 'package:mini_pdv/providers/product_provider.dart';
import 'package:mini_pdv/screens/qr_scanner_screen.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  ProductCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _stockController = TextEditingController(text: '0'); // Inicializa com 0
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, selecione uma categoria')),
        );
        return;
      }
      final id = _idController.text;
      final name = _nameController.text;
      final price = double.parse(_priceController.text);
      final stock = int.parse(_stockController.text);
      Provider.of<ProductProvider>(context, listen: false).add(Product(
        id: id,
        name: name,
        price: price,
        stock: stock,
        category: _selectedCategory!,
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produto cadastrado com sucesso!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _idController,
                        decoration:
                            InputDecoration(labelText: 'Código do Produto'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o código do produto';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.qr_code_scanner),
                      onPressed: () async {
                        final code = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QRScannerScreen()),
                        );
                        if (code != null) {
                          setState(() {
                            _idController.text = code;
                          });
                        }
                      },
                    ),
                  ],
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nome do Produto'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do produto';
                    }
                    return null;
                  },
                ),

                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Preço'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o preço do produto';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, insira um preço válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _stockController,
                  decoration: InputDecoration(labelText: 'Estoque'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a quantidade em estoque';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Por favor, insira um número válido para o estoque';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text('Categoria', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: ProductCategory.values.map((category) {
                    final isSelected = _selectedCategory == category;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      child: Card(
                        color: isSelected ? Theme.of(context).primaryColorLight : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(category.icon, color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700]),
                              SizedBox(width: 8),
                              Text(category.name, style: TextStyle(color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700])),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: Text('Cadastrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
