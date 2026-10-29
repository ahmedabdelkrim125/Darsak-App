import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/models/schedule_view_mode.dart';
import '../../data/schedule_icons.dart';
import 'schedule_card.dart';
import 'schedule_month_grid.dart';
import 'schedule_month_nav.dart';
import 'schedule_view_toggle.dart';
import 'schedule_week_strip.dart';

class ScheduleCalendarCard extends StatelessWidget {
  const ScheduleCalendarCard({
    super.key,
    required this.mode,
    required this.label,
    required this.selected,
    required this.visibleMonth,
    required this.hasLessons,
    required this.onModeChanged,
    required this.onPrevious,
    required this.onNext,
    required this.onPickDate,
    required this.onSelect,
  });

  final ScheduleViewMode mode;
  final String label;
  final DateTime selected;
  final DateTime visibleMonth;
  final bool Function(DateTime date) hasLessons;
  final ValueChanged<ScheduleViewMode> onModeChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onPickDate;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return ScheduleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: palette.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  ScheduleIcons.calendar,
                  size: 22.r,
                  color: palette.primary,
                ),
              ),
              horizontalSpace(width: 8),
              ScheduleViewToggle(mode: mode, onChanged: onModeChanged),
              horizontalSpace(width: 8),
              Expanded(
                child: ScheduleMonthNav(
                  label: label,
                  onPrevious: onPrevious,
                  onNext: onNext,
                  onPickDate: onPickDate,
                ),
              ),
            ],
          ),
          verticalSpace(height: 14),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: KeyedSubtree(
                key: ValueKey(mode),
                child: mode == ScheduleViewMode.week
                    ? ScheduleWeekStrip(
                        selected: selected,
                        hasLessons: hasLessons,
                        onSelect: onSelect,
                      )
                    : ScheduleMonthGrid(
                        month: visibleMonth,
                        selected: selected,
                        hasLessons: hasLessons,
                        onSelect: onSelect,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
