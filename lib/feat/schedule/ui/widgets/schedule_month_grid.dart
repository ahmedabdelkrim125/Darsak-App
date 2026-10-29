import 'package:flutter/material.dart';
import '../../../../core/const/week_days.dart';
import '../../../../core/helper/date_formatter.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import 'schedule_day_tile.dart';

class ScheduleMonthGrid extends StatelessWidget {
  const ScheduleMonthGrid({
    super.key,
    required this.month,
    required this.selected,
    required this.hasLessons,
    required this.onSelect,
  });

  final DateTime month;
  final DateTime selected;
  final bool Function(DateTime date) hasLessons;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final first = DateTime(month.year, month.month);
    final blanks = DateFormatter.leadingBlanks(first);
    final total = DateFormatter.daysInMonth(month.year, month.month);
    final rows = ((blanks + total) / 7).ceil();
    final today = DateTime.now();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            for (var i = 0; i < WeekDays.order.length; i++) ...[
              if (i > 0) horizontalSpace(width: 4),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    WeekDays.label(WeekDays.order[i]),
                    style: AppFonts.bodySmall.copyWith(
                      color: palette.textSecondary,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        verticalSpace(height: 8),
        for (var row = 0; row < rows; row++) ...[
          if (row > 0) verticalSpace(height: 6),
          Row(
            children: [
              for (var col = 0; col < 7; col++) ...[
                if (col > 0) horizontalSpace(width: 4),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final day = row * 7 + col - blanks + 1;
                      if (day < 1 || day > total) {
                        return const SizedBox.shrink();
                      }
                      final date = DateTime(month.year, month.month, day);
                      return ScheduleDayTile(
                        compact: true,
                        date: date,
                        selected: DateFormatter.sameDay(date, selected),
                        isToday: DateFormatter.sameDay(date, today),
                        hasLessons: hasLessons(date),
                        onTap: () => onSelect(date),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
