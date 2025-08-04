
import 'package:flutter/material.dart';
import 'package:flutter_pos/screens/employee_management_screen.dart';
import 'package:flutter_pos/screens/product_management_screen.dart';
import 'package:flutter_pos/screens/company_info_screen.dart';
import 'package:flutter_pos/screens/theme_screen.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Área Administrativa'),
      ),
      body: GridView(
        padding: const EdgeInsets.all(24.0),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: 24.0,
          crossAxisSpacing: 24.0,
          childAspectRatio: 1.0,
        ),
        children: <Widget>[
          _AdminMenuButton(
            icon: Icons.people_alt_outlined,
            label: 'Gerenciar Funcionários',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployeeManagementScreen()),
              );
            },
          ),
          _AdminMenuButton(
            icon: Icons.shopping_bag_outlined,
            label: 'Gerenciar Produtos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductManagementScreen()),
              );
            },
          ),
          _AdminMenuButton(
            icon: Icons.business_center_outlined,
            label: 'Configurações da Empresa',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompanyInfoScreen()),
              );
            },
          ),
          _AdminMenuButton(
            icon: Icons.color_lens_outlined,
            label: 'Tema',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThemeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AdminMenuButton extends StatelessWidget {
  const _AdminMenuButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 48),
          const SizedBox(height: 16),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}