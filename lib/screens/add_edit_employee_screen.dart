

import 'package:flutter/material.dart';
import 'package:flutter_pos/models/employee.dart';
import 'package:flutter_pos/providers/employee_provider.dart';
import 'package:provider/provider.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  final Employee? employee;

  AddEditEmployeeScreen({this.employee});

  @override
  _AddEditEmployeeScreenState createState() => _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late DateTime _birthDate;
  late String _cpf;
  late String _gender;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _name = widget.employee!.name;
      _birthDate = widget.employee!.birthDate;
      _cpf = widget.employee!.cpf;
      _gender = widget.employee!.gender;
    } else {
      _name = '';
      _birthDate = DateTime.now();
      _cpf = '';
      _gender = 'Masculino';
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
      if (widget.employee != null) {
        final updatedEmployee = widget.employee!;
        updatedEmployee.name = _name;
        updatedEmployee.birthDate = _birthDate;
        updatedEmployee.cpf = _cpf;
        updatedEmployee.gender = _gender;
        employeeProvider.updateEmployee(updatedEmployee);
      } else {
        final newEmployee = Employee(
          name: _name,
          birthDate: _birthDate,
          cpf: _cpf,
          gender: _gender,
        );
        employeeProvider.addEmployee(newEmployee);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? 'Adicionar Funcionário' : 'Editar Funcionário'),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  initialValue: _cpf,
                  decoration: InputDecoration(labelText: 'CPF'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o CPF';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _cpf = value!;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: InputDecoration(labelText: 'Sexo'),
                  items: ['Masculino', 'Feminino', 'Outro']
                      .map((label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Text('Data de Nascimento: ${_birthDate.toLocal()}'.split(' ')[0]),
                    ),
                    TextButton(
                      child: Text('Selecionar Data'),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _birthDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            _birthDate = date;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

