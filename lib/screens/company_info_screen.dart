import 'package:flutter/material.dart';
import 'package:flutter_pos/models/company_info.dart';
import 'package:flutter_pos/providers/company_info_provider.dart';
import 'package:provider/provider.dart';

class CompanyInfoScreen extends StatefulWidget {
  @override
  _CompanyInfoScreenState createState() => _CompanyInfoScreenState();
}

class _CompanyInfoScreenState extends State<CompanyInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _taxIdController;

  @override
  void initState() {
    super.initState();
    final companyInfo = Provider.of<CompanyInfoProvider>(context, listen: false).companyInfo;
    _nameController = TextEditingController(text: companyInfo?.name ?? '');
    _addressController = TextEditingController(text: companyInfo?.address ?? '');
    _taxIdController = TextEditingController(text: companyInfo?.taxId ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _taxIdController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newCompanyInfo = CompanyInfo(
        name: _nameController.text,
        address: _addressController.text,
        taxId: _taxIdController.text,
      );
      Provider.of<CompanyInfoProvider>(context, listen: false).saveCompanyInfo(newCompanyInfo);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Informações da empresa salvas com sucesso!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações da Empresa'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome da Empresa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da empresa';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Endereço'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o endereço';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _taxIdController,
                decoration: InputDecoration(labelText: 'CNPJ/CPF'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CNPJ ou CPF';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
