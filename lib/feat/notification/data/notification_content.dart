import 'models/notification_model.dart';
import 'models/notification_type.dart';

class NotificationContent {
  NotificationContent._();

  static List<NotificationModel> seed() {
    final now = DateTime.now();

    DateTime at(int daysAgo, int hour, int minute) {
      return DateTime(now.year, now.month, now.day - daysAgo, hour, minute);
    }

    return [
      NotificationModel(
        id: 'n1',
        type: NotificationType.lessonUpcoming,
        title: 'موعد حصة قادم',
        body: 'لديك حصة الرياضيات - مجموعة أ بعد 15 دقيقة',
        time: at(0, 14, 30),
        pinned: true,
      ),
      NotificationModel(
        id: 'n2',
        type: NotificationType.paymentReceived,
        title: 'تم استلام دفعة',
        body: 'قام الطالب محمد علي بدفع 500 جنيه',
        time: at(0, 12, 15),
      ),
      NotificationModel(
        id: 'n3',
        type: NotificationType.studentAbsent,
        title: 'غياب طالب',
        body: 'الطالبة سارة أحمد لم تحضر حصة الفيزياء',
        time: at(0, 10, 0),
      ),
      NotificationModel(
        id: 'n4',
        type: NotificationType.newMessage,
        title: 'رسالة جديدة',
        body: 'لديك رسالة جديدة من ولي أمر الطالب عمر خالد',
        time: at(0, 9, 20),
        read: true,
      ),
      NotificationModel(
        id: 'n5',
        type: NotificationType.studentJoined,
        title: 'تم إضافة طالب جديد',
        body: 'تم إضافة الطالب يوسف رمضان إلى مجموعة ج',
        time: at(1, 18, 0),
        read: true,
      ),
      NotificationModel(
        id: 'n6',
        type: NotificationType.paymentReminder,
        title: 'تذكير بالدفع',
        body: 'الطالبة منة الله لم تسدد رسوم شهر أكتوبر',
        time: at(1, 16, 30),
        read: true,
      ),
      NotificationModel(
        id: 'n7',
        type: NotificationType.scheduleChanged,
        title: 'تم تعديل جدول حصة',
        body: 'تم تغيير موعد حصة اللغة العربية - مجموعة ب',
        time: at(1, 13, 0),
        read: true,
      ),
      NotificationModel(
        id: 'n8',
        type: NotificationType.reportReady,
        title: 'تقرير أسبوعي جاهز',
        body: 'تقرير حضور الطلاب متاح الآن',
        time: at(1, 11, 20),
        read: true,
      ),
      NotificationModel(
        id: 'n9',
        type: NotificationType.accountVerified,
        title: 'تم توثيق حسابك',
        body: 'تم توثيق حسابك كمعلم بنجاح',
        time: at(3, 20, 45),
        read: true,
      ),
    ];
  }
}
