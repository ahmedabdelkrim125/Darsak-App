import 'package:flutter/material.dart';
import '../../../core/widgets/app_toast.dart';
import '../../classroom/data/classroom_store.dart';
import '../../classroom/ui/add_group_sheet.dart';
import '../../classroom/ui/add_student_sheet.dart';
import 'add_payment_sheet.dart';

class PaymentsActions {
  PaymentsActions._();

  static void addPayment(
    BuildContext context,
    DateTime month, {
    String? studentId,
  }) {
    final store = ClassroomStore.instance;
    if (store.groups.isEmpty) {
      AppToast.show(context, 'أضف مجموعة أولاً');
      AddGroupSheet.show(context);
      return;
    }
    if (store.studentsTotal == 0) {
      AppToast.show(context, 'أضف طالباً أولاً');
      AddStudentSheet.show(context);
      return;
    }
    AddPaymentSheet.show(context, month: month, studentId: studentId);
  }
}
