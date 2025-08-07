import 'package:flutter/material.dart';
import 'package:mini_pdv/enums/hive_boxes.dart';
import 'package:mini_pdv/models/employee.dart';
import 'package:mini_pdv/models/product.dart';
import 'package:mini_pdv/models/cart_item.dart';
import 'package:mini_pdv/models/sale.dart';
import 'package:mini_pdv/models/company_info.dart';
import 'package:mini_pdv/models/product_category.dart';
import 'package:mini_pdv/models/payment_method.dart';
import 'package:mini_pdv/providers/cart_provider.dart';
import 'package:mini_pdv/providers/employee_provider.dart';
import 'package:mini_pdv/providers/product_provider.dart';
import 'package:mini_pdv/providers/sales_provider.dart';
import 'package:mini_pdv/providers/company_info_provider.dart';
import 'package:mini_pdv/providers/theme_provider.dart';
import 'package:mini_pdv/screens/login_screen.dart';
import 'package:mini_pdv/widgets/Spacial_will.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:provider/provider.dart';


void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(SaleAdapter());
  Hive.registerAdapter(CompanyInfoAdapter());
  Hive.registerAdapter(EmployeeAdapter());
  Hive.registerAdapter(PaymentMethodAdapter());
  Hive.registerAdapter(ProductCategoryAdapter());

  await Hive.openBox<Product>(HiveBoxes.products.name);
  await Hive.openBox<CartItem>(HiveBoxes.cart.name);
  await Hive.openBox<Sale>(HiveBoxes.sales.name);
  await Hive.openBox<CompanyInfo>(HiveBoxes.company_info.name);
  await Hive.openBox<Employee>(HiveBoxes.employees.name);
  await Hive.openBox(HiveBoxes.settings.name);

  final productProvider = ProductProvider();
  if (productProvider.products.isEmpty) {
    productProvider.add(Product(id: '1', name: 'Coca-Cola', price: 5.0, category: ProductCategory.drink, stock: 5));
    productProvider.add(Product(id: '2', name: 'X-Burger', price: 15.0, category: ProductCategory.food));
    productProvider.add(Product(id: '3', name: 'Batata Frita', price: 10.0, category: ProductCategory.food));
  }

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => SalesProvider()),
        ChangeNotifierProvider(create: (_) => CompanyInfoProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier(Hive.box(HiveBoxes.settings.name))),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            builder: (context, child) {
              return SpacialWill(
                child: child ?? const SizedBox.shrink(),
              );
            },
            color: themeNotifier.primaryColor,
            title: 'mini pdv',
            theme: ThemeData(
             
              iconTheme: IconThemeData(color: themeNotifier.primaryColor),
              
              primaryColor: themeNotifier.primaryColor,
              colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: MaterialColor(themeNotifier.primaryColor.value, <int, Color>{
                50: themeNotifier.primaryColor.withOpacity(0.1),
                100: themeNotifier.primaryColor.withOpacity(0.2),
                200: themeNotifier.primaryColor.withOpacity(0.3),
                300: themeNotifier.primaryColor.withOpacity(0.4),
                400: themeNotifier.primaryColor.withOpacity(0.5),
                500: themeNotifier.primaryColor.withOpacity(0.6),
                600: themeNotifier.primaryColor.withOpacity(0.7),
                700: themeNotifier.primaryColor.withOpacity(0.8),
                800: themeNotifier.primaryColor.withOpacity(0.9),
                900: themeNotifier.primaryColor.withOpacity(1.0),
              })).copyWith(secondary: themeNotifier.secondaryColor),
            ),
            home: LoginScreen(),
          );
        },
      ),
    );
  }
}
