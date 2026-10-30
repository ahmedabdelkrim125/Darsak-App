import 'package:flutter/widgets.dart';
import 'more_action.dart';
import 'more_tone.dart';

class MoreItemModel {
  const MoreItemModel({
    required this.action,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tone,
  });

  final MoreAction action;
  final IconData icon;
  final String title;
  final String subtitle;
  final MoreTone tone;
}
