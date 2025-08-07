
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos/providers/employee_provider.dart';
import 'package:flutter_pos/screens/add_edit_employee_screen.dart';
import 'package:provider/provider.dart';

class EmployeeManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Funcionários'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEditEmployeeScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: employeeProvider.employees.length,
        itemBuilder: (context, index) {
          final employee = employeeProvider.employees[index];
          return ListTile(
            title: Text(employee.name),
            leading: CircleAvatar(
              child: Text(employee.name[0]),
            ),
            subtitle: Text('Código: ${employee.id}\nCPF: ${employee.cpf} - Sexo: ${employee.gender}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: employee.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Código copiado para a área de transferência')),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditEmployeeScreen(employee: employee),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    employeeProvider.deleteEmployee(employee.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
