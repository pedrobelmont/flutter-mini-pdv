
import 'package:flutter/material.dart';
import 'package:flutter_pos/enums/hive_boxes.dart';
import 'package:hive_ce/hive.dart';

class ThemeNotifier extends ChangeNotifier {
  final Box _box;

  ThemeNotifier(this._box);

  Color get primaryColor => Color(_box.get('primaryColor', defaultValue: Colors.blue.value));
  Color get secondaryColor => Color(_box.get('secondaryColor', defaultValue: Colors.blueAccent.value));

  Future<void> setThemeColors(Color primary, Color secondary) async {
    await _box.put('primaryColor', primary.value);
    await _box.put('secondaryColor', secondary.value);
    notifyListeners();
  }
}
