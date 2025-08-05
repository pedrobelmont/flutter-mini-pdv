import 'dart:convert';
import 'package:flutter/material.dart';

class SpacialWill extends StatelessWidget {
  final Widget child;

  const 
SpacialWill({super.key, required this.child});

  static const _encodedCredit = 'Y3JpYWRvIHBvciAtIGdpdGh1YiBwZWRyb2JlbG1vbnQ=';

  String get _joker {
    try {
      return utf8.decode(base64.decode(_encodedCredit));
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        child,
        IgnorePointer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: Text(
              _joker,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5) ?? Colors.blueAccent,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
