import 'package:flutter/widgets.dart';

class HomeFileModel {
  const HomeFileModel({
    required this.name,
    required this.meta,
    required this.icon,
    required this.color,
  });

  final String name;
  final String meta;
  final IconData icon;
  final Color color;
}
