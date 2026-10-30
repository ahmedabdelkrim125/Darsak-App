import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../../home/data/models/home_tone.dart';
import '../../../schedule/ui/widgets/schedule_card.dart';
import '../../data/models/payment_entry.dart';
import '../../data/payments_content.dart';
import '../../data/payments_icons.dart';
import 'payment_student_row.dart';
import 'payments_empty.dart';

class PaymentsStudentsSection extends StatelessWidget {
  const PaymentsStudentsSection({
    super.key,
    required this.entries,
    required this.hasStudents,
    required this.filterActive,
    required this.onFilter,
    required this.onTap,
    required this.onMenu,
  });

  final List<PaymentEntry> entries;
  final bool hasStudents;
  final bool filterActive;
  final VoidCallback onFilter;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onMenu;

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
                Icon(
                  PaymentsIcons.students,
                  size: 24.r,
                  color: palette.textPrimary,
                ),
                horizontalSpace(width: 8),
                Text(
                  PaymentsContent.studentsList,
                  style: AppFonts.titleMedium.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                const Spacer(),
                AppPressable(
                  onTap: onFilter,
                  pressedScale: 0.95,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: filterActive
                          ? palette.primary
                          : palette.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          PaymentsIcons.filter,
                          size: 18.r,
                          color: filterActive
                              ? palette.onPrimary
                              : palette.primary,
                        ),
                        horizontalSpace(width: 6),
                        Text(
                          PaymentsContent.filter,
                          style: AppFonts.labelMedium.copyWith(
                            color: filterActive
                                ? palette.onPrimary
                                : palette.primary,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(height: 14),
          if (entries.isEmpty)
            PaymentsEmpty(
              title: hasStudents
                  ? PaymentsContent.noResults
                  : PaymentsContent.emptyTitle,
              description: hasStudents
                  ? PaymentsContent.noResultsDescription
                  : PaymentsContent.emptyDescription,
            )
          else
            for (var i = 0; i < entries.length; i++) ...[
              if (i > 0) verticalSpace(height: 8),
              PaymentStudentRow(
                entry: entries[i],
                tone: HomeTone.values[i % HomeTone.values.length],
                onTap: () => onTap(entries[i].studentId),
                onMenu: () => onMenu(entries[i].studentId),
              ),
            ],
        ],
      ),
    );
  }
}
