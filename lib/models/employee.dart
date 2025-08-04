import 'dart:math';

import 'package:hive_ce/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 3)
class Employee extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime birthDate;

  @HiveField(3)
  String cpf;

  @HiveField(4)
  String gender;

  Employee({
    required this.name,
    required this.birthDate,
    required this.cpf,
    required this.gender,
  }) {
    id = _generateEmployeeId(birthDate);
  }

  String _generateEmployeeId(DateTime birthDate) {
    final day = DateTime.now().day.toString().padLeft(2, '0');
    final birthDay = birthDate.day.toString().padLeft(2, '0');
    final random = (Random().nextInt(9000) + 1000).toString();
    return '$day$birthDay$random';
  }
}

