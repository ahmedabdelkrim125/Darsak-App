import 'package:flutter/material.dart';
import '../../../../core/helper/date_formatter.dart';
import '../../../../core/helper/spacing.dart';
import 'schedule_day_tile.dart';

class ScheduleWeekStrip extends StatelessWidget {
  const ScheduleWeekStrip({
    super.key,
    required this.selected,
    required this.hasLessons,
    required this.onSelect,
  });

  final DateTime selected;
  final bool Function(DateTime date) hasLessons;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final start = DateFormatter.startOfWeek(selected);
    final today = DateTime.now();

    return Row(
      children: [
        for (var i = 0; i < 7; i++) ...[
          if (i > 0) horizontalSpace(width: 6),
          Expanded(
            child: Builder(
              builder: (context) {
                final date = DateTime(start.year, start.month, start.day + i);
                return ScheduleDayTile(
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
    );
  }
}
