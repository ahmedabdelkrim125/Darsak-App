import 'package:flutter/widgets.dart';
import 'more_item_model.dart';

class MoreSectionModel {
  const MoreSectionModel({
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final IconData icon;
  final List<MoreItemModel> items;
}
