import 'package:hive_ce/hive.dart';

part 'company_info.g.dart';

@HiveType(typeId: 4)
class CompanyInfo extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String address;

  @HiveField(2)
  String taxId;

  CompanyInfo({
    required this.name,
    required this.address,
    required this.taxId,
  });
}
