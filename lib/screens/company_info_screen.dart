import 'package:flutter/material.dart';
import 'package:flutter_pos/models/company_info.dart';
import 'package:flutter_pos/providers/company_info_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pos/utils/cpf_cnpj_formatter.dart';

class CompanyInfoScreen extends StatefulWidget {
  @override
  _CompanyInfoScreenState createState() => _CompanyInfoScreenState();
}

class _CompanyInfoScreenState extends State<CompanyInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _taxIdController;
  String? _selectedState;

  final List<String> _brazilianStates = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG',
    'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
  ];

  @override
  void initState() {
    super.initState();
    final companyInfo = Provider.of<CompanyInfoProvider>(context, listen: false).companyInfo;
    _nameController = TextEditingController(text: companyInfo?.name ?? '');
    _taxIdController = TextEditingController(text: companyInfo?.taxId ?? '');

    String address = companyInfo?.address ?? '';
    String addressWithoutState = address;

    if (address.isNotEmpty) {
      final addressParts = address.split(',');
      if (addressParts.length > 1) {
        final potentialState = addressParts.last.trim().toUpperCase();
        if (_brazilianStates.contains(potentialState)) {
          _selectedState = potentialState;
          addressWithoutState = addressParts.sublist(0, addressParts.length - 1).join(',').trim();
        }
      }
    }
    _addressController = TextEditingController(text: addressWithoutState);
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
      String fullAddress = _addressController.text;
      if (_selectedState != null && _selectedState!.isNotEmpty) {
        fullAddress = '$fullAddress, $_selectedState';
      }

      final newCompanyInfo = CompanyInfo(
        name: _nameController.text,
        address: fullAddress.trim(),
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

              Row( 
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                    value: _selectedState,
                    hint: Text('UF'),
                    items: _brazilianStates.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedState = newValue;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(labelText: 'Endereço (Rua, N°, Bairro, Cidade)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o endereço';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _taxIdController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CpfCnpjInputFormatter(),
                ],
                decoration: InputDecoration(labelText: 'CNPJ/CPF'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CNPJ ou CPF';
                  }
                  final unmasked = value.replaceAll(RegExp(r'[^\d]'), '');
                  if (unmasked.length != 11 && unmasked.length != 14) {
                    return 'CPF ou CNPJ inválido';
                  }
                  return null; // Válido
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
