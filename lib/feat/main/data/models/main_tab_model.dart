import 'package:flutter/material.dart';

enum MainTabId { home, schedule, groups, payments, more }

class MainTabModel {
  const MainTabModel({
    required this.id,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final MainTabId id;
  final String label;
  final IconData icon;
  final IconData activeIcon;
}
