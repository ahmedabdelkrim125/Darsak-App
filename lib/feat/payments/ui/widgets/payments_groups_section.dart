import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../schedule/ui/widgets/schedule_card.dart';
import '../../data/models/payment_group_summary.dart';
import '../../data/payments_content.dart';
import '../../data/payments_icons.dart';
import 'payments_empty.dart';
import 'payments_group_card.dart';

class PaymentsGroupsSection extends StatelessWidget {
  const PaymentsGroupsSection({
    super.key,
    required this.groups,
    required this.onTap,
  });

  final List<PaymentGroupSummary> groups;
  final ValueChanged<String> onTap;

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
                  PaymentsContent.groupsList,
                  style: AppFonts.titleMedium.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(height: 14),
          if (groups.isEmpty)
            const PaymentsEmpty(
              title: PaymentsContent.emptyTitle,
              description: PaymentsContent.emptyDescription,
            )
          else
            for (var i = 0; i < groups.length; i++) ...[
              if (i > 0) verticalSpace(height: 10),
              PaymentsGroupCard(
                group: groups[i],
                onTap: () => onTap(groups[i].groupId),
              ),
            ],
        ],
      ),
    );
  }
}
