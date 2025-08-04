
import 'package:flutter/material.dart';
import 'package:flutter_pos/enums/hive_boxes.dart';
import 'package:flutter_pos/models/employee.dart';
import 'package:hive_ce/hive.dart';

class EmployeeProvider with ChangeNotifier {
  Box<Employee> _employeeBox;

  EmployeeProvider() : _employeeBox = Hive.box<Employee>(HiveBoxes.employees.name);

  List<Employee> get employees => _employeeBox.values.toList();

  void addEmployee(Employee employee) {
    _employeeBox.put(employee.id, employee);
    notifyListeners();
  }

  void updateEmployee(Employee employee) {
    _employeeBox.put(employee.id, employee);
    notifyListeners();
  }

  void deleteEmployee(String id) {
    _employeeBox.delete(id);
    notifyListeners();
  }

  Employee? getEmployeeByLoginCode(String loginCode) {
    try {
      return employees.firstWhere((employee) => employee.id == loginCode);
    } catch (e) {
      return null;
    }
  }

  bool isEntryCodeValid(String entryCode) {
    return employees.any((employee) => employee.name == entryCode);
  }
}
