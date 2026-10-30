import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/models/payments_tab.dart';
import '../../data/payments_content.dart';

class PaymentsTabSwitch extends StatelessWidget {
  const PaymentsTabSwitch({
    super.key,
    required this.tab,
    required this.onChanged,
  });

  final PaymentsTab tab;
  final ValueChanged<PaymentsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: palette.primary.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segment(
              label: PaymentsContent.studentsTab,
              selected: tab == PaymentsTab.students,
              onTap: () => onChanged(PaymentsTab.students),
            ),
          ),
          Expanded(
            child: _Segment(
              label: PaymentsContent.groupsTab,
              selected: tab == PaymentsTab.groups,
              onTap: () => onChanged(PaymentsTab.groups),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.97,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        height: 44.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: selected
              ? LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [palette.primary, palette.accent],
                )
              : null,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: palette.primary.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppFonts.bodyMedium.copyWith(
            color: selected ? Colors.white : palette.textSecondary,
          ),
        ),
      ),
    );
  }
}
