import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_switch.dart';
import '../../../schedule/ui/widgets/schedule_card.dart';
import '../../data/models/more_action.dart';
import '../../data/models/more_section_model.dart';
import 'more_item_tile.dart';

class MoreSectionCard extends StatelessWidget {
  const MoreSectionCard({
    super.key,
    required this.section,
    required this.onTap,
    required this.darkMode,
    required this.onDarkChanged,
  });

  final MoreSectionModel section;
  final ValueChanged<MoreAction> onTap;
  final bool darkMode;
  final ValueChanged<bool> onDarkChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return ScheduleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Icon(section.icon, size: 24.r, color: palette.textPrimary),
                horizontalSpace(width: 8),
                Text(
                  section.title,
                  style: AppFonts.titleMedium.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: Container(
              color: palette.background,
              child: Column(
                children: [
                  for (var i = 0; i < section.items.length; i++) ...[
                    if (i > 0)
                      Container(
                        height: 1,
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                        color: palette.primary.withValues(alpha: 0.06),
                      ),
                    MoreItemTile(
                      item: section.items[i],
                      onTap: () => onTap(section.items[i].action),
                      trailing: section.items[i].action == MoreAction.darkMode
                          ? AppSwitch(value: darkMode, onChanged: onDarkChanged)
                          : null,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
