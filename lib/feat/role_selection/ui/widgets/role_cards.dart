import 'package:flutter/material.dart';
import '../../data/role_options.dart';
import '../../../../core/const/user_role.dart';
import '../../../../core/helper/responsive_extension.dart';
import 'role_card.dart';

class RoleCards extends StatelessWidget {
  const RoleCards({super.key, required this.selected, required this.onSelect});

  final UserRole? selected;
  final ValueChanged<UserRole> onSelect;

  @override
  Widget build(BuildContext context) {
    const items = RoleOptions.items;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) SizedBox(width: 12.w),
            Expanded(
              child: RoleCard(
                option: items[i],
                selected: selected == items[i].role,
                onTap: () => onSelect(items[i].role),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
