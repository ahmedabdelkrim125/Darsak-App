import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/models/attendance_summary.dart';

class AttendanceSummaryRow extends StatelessWidget {
  const AttendanceSummaryRow({super.key, required this.summary});

  final AttendanceSummary summary;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Expanded(
          child: _Stat(
            label: 'حضور',
            value: '${summary.present}',
            color: palette.success,
          ),
        ),
        horizontalSpace(width: 8),
        Expanded(
          child: _Stat(
            label: 'غياب',
            value: '${summary.absent}',
            color: palette.error,
          ),
        ),
        horizontalSpace(width: 8),
        Expanded(
          child: _Stat(
            label: 'تأخير',
            value: '${summary.lateCount}',
            color: const Color(0xFFF59E0B),
          ),
        ),
        horizontalSpace(width: 8),
        Expanded(
          child: _Stat(
            label: 'الالتزام',
            value: summary.rateLabel,
            color: palette.primary,
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppFonts.titleLarge.copyWith(color: color, height: 1.2),
          ),
          verticalSpace(height: 2),
          Text(
            label,
            style: AppFonts.bodySmall.copyWith(color: palette.textSecondary),
          ),
        ],
      ),
    );
  }
}
