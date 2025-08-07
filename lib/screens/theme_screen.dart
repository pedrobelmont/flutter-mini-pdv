
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import 'package:mini_pdv/providers/theme_provider.dart';

class ThemeScreen extends StatefulWidget {
  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  late Color _primaryColor;
  late Color _secondaryColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _primaryColor = themeNotifier.primaryColor;
    _secondaryColor = themeNotifier.secondaryColor;
  }

  void _changeColor(Color color, bool isPrimary) {
    setState(() {
      if (isPrimary) {
        _primaryColor = color;
      } else {
        _secondaryColor = color;
      }
    });
  }

  void _saveColors() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    themeNotifier.setThemeColors(_primaryColor, _secondaryColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Primary Color'),
              trailing: CircleAvatar(
                backgroundColor: _primaryColor,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Select Primary Color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: _primaryColor,
                          onColorChanged: (color) =>
                              _changeColor(color, true),
                          showLabel: true,
                          pickerAreaHeightPercent: 0.8,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Done'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              title: Text('Secondary Color'),
              trailing: CircleAvatar(
                backgroundColor: _secondaryColor,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Select Secondary Color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: _secondaryColor,
                          onColorChanged: (color) =>
                              _changeColor(color, false),
                          showLabel: true,
                          pickerAreaHeightPercent: 0.8,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Done'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveColors,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
