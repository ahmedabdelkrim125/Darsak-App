import 'package:flutter/widgets.dart';
import 'home_tone.dart';

enum HomeQuickActionId { addLesson, addGroup, addStudent, uploadContent }

class HomeQuickActionModel {
  const HomeQuickActionModel({
    required this.id,
    required this.label,
    required this.icon,
    required this.tone,
  });

  final HomeQuickActionId id;
  final String label;
  final IconData icon;
  final HomeTone tone;
}
