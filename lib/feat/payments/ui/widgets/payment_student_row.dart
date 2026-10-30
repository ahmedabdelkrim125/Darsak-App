import 'package:flutter/material.dart';
import '../../../../core/helper/date_formatter.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../../home/data/models/home_tone.dart';
import '../../data/models/payment_entry.dart';
import '../../data/models/payment_status.dart';
import '../../data/payments_content.dart';
import '../../data/payments_icons.dart';
import 'payment_status_pill.dart';

class PaymentStudentRow extends StatelessWidget {
  const PaymentStudentRow({
    super.key,
    required this.entry,
    required this.tone,
    required this.onTap,
    required this.onMenu,
  });

  final PaymentEntry entry;
  final HomeTone tone;
  final VoidCallback onTap;
  final VoidCallback onMenu;

  String get _amountText {
    if (entry.status == PaymentStatus.partial) {
      return '${entry.paid} من ${entry.fee} ${PaymentsContent.currency}';
    }
    return '${entry.fee} ${PaymentsContent.currency}';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final toneColor = tone.resolve(palette);
    final name = entry.studentName.trim();
    final initial = name.isEmpty ? '؟' : String.fromCharCode(name.runes.first);
    final paidAt = entry.lastPaidAt;
    final smallStyle = AppFonts.bodySmall.copyWith(
      color: palette.textSecondary,
      fontSize: 11.sp,
    );

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.98,
      child: Container(
        padding: EdgeInsets.fromLTRB(10.w, 10.h, 2.w, 10.h),
        decoration: BoxDecoration(
          color: palette.background,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: palette.primary.withValues(alpha: 0.05)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 42.r,
              height: 42.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: toneColor.withValues(alpha: 0.15),
              ),
              child: Text(
                initial,
                style: AppFonts.titleMedium.copyWith(color: toneColor),
              ),
            ),
            horizontalSpace(width: 10),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      entry.studentName,
                      maxLines: 1,
                      style: AppFonts.titleMedium.copyWith(
                        color: palette.textPrimary,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  verticalSpace(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          PaymentsIcons.student,
                          size: 12.r,
                          color: palette.textSecondary,
                        ),
                        horizontalSpace(width: 3),
                        Text(entry.yearLabel, style: smallStyle),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            horizontalSpace(width: 6),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      entry.groupName,
                      maxLines: 1,
                      style: AppFonts.bodyMedium.copyWith(
                        color: palette.textPrimary,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  verticalSpace(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(entry.subject, maxLines: 1, style: smallStyle),
                  ),
                ],
              ),
            ),
            horizontalSpace(width: 6),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaymentStatusPill(status: entry.status),
                verticalSpace(height: 4),
                Text(
                  _amountText,
                  style: AppFonts.bodySmall.copyWith(
                    color: entry.status == PaymentStatus.unpaid
                        ? palette.textSecondary
                        : palette.textPrimary,
                    fontSize: 12.sp,
                  ),
                ),
                verticalSpace(height: 2),
                if (paidAt == null)
                  Text('—', style: smallStyle)
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PaymentsIcons.calendar,
                        size: 12.r,
                        color: palette.textSecondary,
                      ),
                      horizontalSpace(width: 3),
                      Text(
                        DateFormatter.shortDate(paidAt),
                        style: smallStyle.copyWith(fontSize: 10.sp),
                      ),
                    ],
                  ),
              ],
            ),
            AppPressable(
              onTap: onMenu,
              pressedScale: 0.85,
              child: SizedBox(
                width: 30.w,
                height: 44.h,
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      PaymentsIcons.menu,
                      size: 20.r,
                      color: palette.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
