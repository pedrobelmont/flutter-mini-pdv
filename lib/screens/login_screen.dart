
import 'package:flutter/material.dart';
import 'package:flutter_pos/providers/employee_provider.dart';
import 'package:flutter_pos/screens/admin_screen.dart';
import 'package:flutter_pos/screens/pos_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
      final employee = employeeProvider.getEmployeeByLoginCode(_controller.text);
      if (employee != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PosScreen(employeeName: employee.name)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Código de funcionário inválido')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login de Funcionário'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('asset/img/logo.png', width: 200,),
                TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, size: 22,),
                 
                    labelText: 'Código de Funcionário',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o código';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  ),
                  
                  onPressed: _login,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    Icon(Icons.login, size: 18,),
                    SizedBox(width: 10),
                    Text('Entrar', style: TextStyle(fontSize: 18),),
                  ],),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
