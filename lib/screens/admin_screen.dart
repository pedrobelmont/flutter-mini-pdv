
import 'package:flutter/material.dart';
import 'package:mini_pdv/screens/dashboard_screen.dart';
import 'package:mini_pdv/screens/employee_management_screen.dart';
import 'package:mini_pdv/screens/product_management_screen.dart';
import 'package:mini_pdv/screens/company_info_screen.dart';
import 'package:mini_pdv/screens/theme_screen.dart';

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
          _AdminMenuButton(
            icon: Icons.browser_updated,
            label: 'Monitoramento',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            }
          )
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
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child: Icon(icon, size: 48)),
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