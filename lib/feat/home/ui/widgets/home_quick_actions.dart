import 'package:flutter/material.dart';
import '../../../../core/helper/spacing.dart';
import '../../data/models/home_quick_action_model.dart';
import 'home_quick_action_item.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({
    super.key,
    required this.actions,
    required this.onTap,
  });

  final List<HomeQuickActionModel> actions;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          if (i > 0) horizontalSpace(width: 10),
          Expanded(
            child: HomeQuickActionItem(action: actions[i], onTap: onTap),
          ),
        ],
      ],
    );
  }
}
