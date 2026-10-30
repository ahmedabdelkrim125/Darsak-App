import 'package:flutter/material.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_button_style.dart';
import '../../classroom/data/classroom_store.dart';
import '../../classroom/ui/widgets/classroom_chip.dart';
import '../../classroom/ui/widgets/sheet_label.dart';
import '../data/models/payment_filter.dart';
import '../data/models/payment_status.dart';

class PaymentFilterSheet extends StatefulWidget {
  const PaymentFilterSheet({super.key, required this.initial});

  final PaymentFilter initial;

  static Future<PaymentFilter?> show(
    BuildContext context,
    PaymentFilter initial,
  ) {
    return AppBottomSheet.show<PaymentFilter>(
      context,
      title: 'تصفية الطلاب',
      child: PaymentFilterSheet(initial: initial),
    );
  }

  @override
  State<PaymentFilterSheet> createState() => _PaymentFilterSheetState();
}

class _PaymentFilterSheetState extends State<PaymentFilterSheet> {
  late PaymentStatus? _status = widget.initial.status;
  late String? _groupId = widget.initial.groupId;

  @override
  Widget build(BuildContext context) {
    final groups = ClassroomStore.instance.groups;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SheetLabel('حالة الدفع'),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            ClassroomChip(
              label: 'الكل',
              selected: _status == null,
              onTap: () => setState(() => _status = null),
            ),
            for (final status in PaymentStatus.values)
              ClassroomChip(
                label: status.label,
                selected: _status == status,
                onTap: () => setState(() => _status = status),
              ),
          ],
        ),
        verticalSpace(height: 16),
        const SheetLabel('المجموعة'),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            ClassroomChip(
              label: 'الكل',
              selected: _groupId == null,
              onTap: () => setState(() => _groupId = null),
            ),
            for (final group in groups)
              ClassroomChip(
                label: '${group.name} · ${group.year.label}',
                selected: _groupId == group.id,
                onTap: () => setState(() => _groupId = group.id),
              ),
          ],
        ),
        verticalSpace(height: 20),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'إعادة ضبط',
                variant: AppButtonVariant.soft,
                expanded: true,
                onPressed: () =>
                    Navigator.of(context).pop(const PaymentFilter()),
              ),
            ),
            horizontalSpace(width: 10),
            Expanded(
              child: AppButton(
                label: 'تطبيق',
                expanded: true,
                onPressed: () => Navigator.of(
                  context,
                ).pop(PaymentFilter(status: _status, groupId: _groupId)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
