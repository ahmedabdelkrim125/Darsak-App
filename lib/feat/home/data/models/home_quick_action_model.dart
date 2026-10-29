import 'package:flutter/widgets.dart';
import 'home_tone.dart';

class HomeQuickActionModel {
  const HomeQuickActionModel({
    required this.label,
    required this.icon,
    required this.tone,
  });

  final String label;
  final IconData icon;
  final HomeTone tone;
}
