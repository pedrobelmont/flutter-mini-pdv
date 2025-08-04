import 'package:flutter/material.dart';
import 'package:flutter_pos/enums/hive_boxes.dart';
import 'package:flutter_pos/models/company_info.dart';
import 'package:hive_ce/hive.dart';

class CompanyInfoProvider with ChangeNotifier {
  late Box<CompanyInfo> _companyInfoBox;
  CompanyInfo? _companyInfo;

  CompanyInfoProvider() {
    _companyInfoBox = Hive.box<CompanyInfo>(HiveBoxes.company_info.name);
    _companyInfo = _companyInfoBox.get('currentCompany');
  }

  CompanyInfo? get companyInfo => _companyInfo;

  void saveCompanyInfo(CompanyInfo info) {
    _companyInfo = info;
    _companyInfoBox.put('currentCompany', info);
    notifyListeners();
  }
}
