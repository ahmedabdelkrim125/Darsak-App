import 'models/more_action.dart';
import 'models/more_item_model.dart';
import 'models/more_section_model.dart';
import 'models/more_tone.dart';
import 'more_icons.dart';

class MoreContent {
  MoreContent._();

  static const String supportEmail = 'support@darsak.app';
  static const String appName = 'درسّك';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'منصتك لتنظيم حصصك ومجموعاتك وطلابك ومدفوعاتهم في مكان واحد.';

  static const String editProfileAction = 'تعديل الملف الشخصي';
  static const String verifiedTitle = 'حساب موثق';
  static const String verifiedDescription =
      'تم التحقق من بياناتك كمعلم مما يمنحك وصولاً إلى جميع المميزات.';
  static const String verifiedAction = 'عرض التفاصيل';
  static const String unverifiedTitle = 'حسابك غير موثق';
  static const String unverifiedDescription =
      'وثّق حسابك كمعلم لتحصل على شارة التوثيق وجميع المميزات.';
  static const String unverifiedAction = 'وثّق الآن';

  static const String logoutTitle = 'تسجيل الخروج';
  static const String logoutSubtitle = 'الخروج من حسابك الحالي';

  static const List<MoreSectionModel> sections = [
    MoreSectionModel(
      title: 'الحساب',
      icon: MoreIcons.accountSection,
      items: [
        MoreItemModel(
          action: MoreAction.editProfile,
          icon: MoreIcons.editProfile,
          title: 'تعديل الملف الشخصي',
          subtitle: 'تحديث بياناتك الشخصية والمهنية',
          tone: MoreTone.primary,
        ),
        MoreItemModel(
          action: MoreAction.publicProfile,
          icon: MoreIcons.publicProfile,
          title: 'الملف العام للمعلم',
          subtitle: 'معاينة ملفك كما يراه الطلاب',
          tone: MoreTone.accent,
        ),
        MoreItemModel(
          action: MoreAction.verification,
          icon: MoreIcons.verification,
          title: 'توثيق المعلم',
          subtitle: 'إثبات هويتك كمعلم',
          tone: MoreTone.primary,
        ),
        MoreItemModel(
          action: MoreAction.subscription,
          icon: MoreIcons.subscription,
          title: 'إدارة الاشتراك',
          subtitle: 'ترقية الباقة وإدارة الاشتراك',
          tone: MoreTone.amber,
        ),
      ],
    ),
    MoreSectionModel(
      title: 'المظهر واللغة',
      icon: MoreIcons.appearanceSection,
      items: [
        MoreItemModel(
          action: MoreAction.darkMode,
          icon: MoreIcons.darkMode,
          title: 'الوضع الداكن',
          subtitle: 'تغيير مظهر التطبيق',
          tone: MoreTone.primary,
        ),
        MoreItemModel(
          action: MoreAction.language,
          icon: MoreIcons.language,
          title: 'اللغة',
          subtitle: 'العربية (اللغة الحالية)',
          tone: MoreTone.primary,
        ),
      ],
    ),
    MoreSectionModel(
      title: 'الإشعارات',
      icon: MoreIcons.notificationsSection,
      items: [
        MoreItemModel(
          action: MoreAction.notifications,
          icon: MoreIcons.notifications,
          title: 'إعدادات الإشعارات',
          subtitle: 'إدارة تنبيهات الحصص والمدفوعات والمجموعات',
          tone: MoreTone.accent,
        ),
      ],
    ),
    MoreSectionModel(
      title: 'الدعم والمساعدة',
      icon: MoreIcons.supportSection,
      items: [
        MoreItemModel(
          action: MoreAction.help,
          icon: MoreIcons.help,
          title: 'مركز المساعدة',
          subtitle: 'الأسئلة الشائعة والدعم الفني',
          tone: MoreTone.primary,
        ),
        MoreItemModel(
          action: MoreAction.contact,
          icon: MoreIcons.contact,
          title: 'تواصل معنا',
          subtitle: 'أرسل لنا رسالة أو اقتراح',
          tone: MoreTone.accent,
        ),
        MoreItemModel(
          action: MoreAction.about,
          icon: MoreIcons.about,
          title: 'عن التطبيق',
          subtitle: 'الإصدار $appVersion',
          tone: MoreTone.primary,
        ),
      ],
    ),
  ];
}
