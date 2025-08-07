

import 'package:flutter/material.dart';
import 'package:flutter_pos/models/employee.dart';
import 'package:flutter_pos/providers/employee_provider.dart';
import 'package:flutter_pos/screens/add_edit_employee_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_ffi/path_provider_ffi.dart';

import 'package:provider/provider.dart';

void main() {
  group('AddEditEmployeeScreen', () {
    late EmployeeProvider employeeProvider;
    late Box<Employee> employeeBox;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
      Hive.registerAdapter(EmployeeAdapter());
      await Hive.openBox<Employee>('employees');
    });

    setUp(() {
      employeeBox = Hive.box<Employee>('employees');
      employeeProvider = EmployeeProvider();
    });

    tearDown(() async {
      await employeeBox.clear();
    });

    tearDownAll(() async {
      await Hive.close();
    });

    testWidgets('should add an employee when the form is saved', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: employeeProvider,
          child: MaterialApp(
            home: AddEditEmployeeScreen(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(find.byType(TextFormField).at(1), '123.456.789-00');
      await tester.tap(find.byType(DropdownButtonFormField));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Masculino').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      expect(employeeProvider.employees.length, 1);
      expect(employeeProvider.employees.first.name, 'John Doe');
    });

    testWidgets('should update an employee when the form is saved', (WidgetTester tester) async {
      final employee = Employee(
        name: 'Jane Doe',
        birthDate: DateTime.now(),
        cpf: '111.222.333-44',
        gender: 'Feminino',
      );
      employeeProvider.addEmployee(employee);

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: employeeProvider,
          child: MaterialApp(
            home: AddEditEmployeeScreen(employee: employee),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'Jane Doe Smith');
      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      expect(employeeProvider.employees.length, 1);
      expect(employeeProvider.employees.first.name, 'Jane Doe Smith');
    });

    testWidgets('should show validation errors when the form is saved with empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: employeeProvider,
          child: MaterialApp(
            home: AddEditEmployeeScreen(),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      expect(find.text('Por favor, insira o nome'), findsOneWidget);
      expect(find.text('Por favor, insira o CPF'), findsOneWidget);
    });
  });
}