import 'package:flutter/material.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/settings/app_settings.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_choice_chips.dart';
import '../../../core/widgets/app_page_scaffold.dart';
import '../../../core/widgets/app_switch.dart';
import '../../schedule/ui/widgets/schedule_card.dart';
import '../data/models/more_action.dart';
import '../data/models/more_item_model.dart';
import '../data/models/more_tone.dart';
import '../data/more_icons.dart';
import 'widgets/more_item_tile.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  static const MoreItemModel _lessons = MoreItemModel(
    action: MoreAction.notifications,
    icon: MoreIcons.lessons,
    title: 'تنبيهات الحصص',
    subtitle: 'تذكير قبل بداية كل حصة',
    tone: MoreTone.primary,
  );

  static const MoreItemModel _payments = MoreItemModel(
    action: MoreAction.notifications,
    icon: MoreIcons.payments,
    title: 'تنبيهات المدفوعات',
    subtitle: 'متابعة الدفعات والمتأخرين',
    tone: MoreTone.accent,
  );

  static const MoreItemModel _groups = MoreItemModel(
    action: MoreAction.notifications,
    icon: MoreIcons.groups,
    title: 'تنبيهات المجموعات',
    subtitle: 'انضمام الطلاب وتحديثات المجموعات',
    tone: MoreTone.primary,
  );

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final settings = AppSettings.instance;

    Widget divider() => Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      color: palette.primary.withValues(alpha: 0.06),
    );

    return AppPageScaffold(
      title: 'إعدادات الإشعارات',
      child: ListenableBuilder(
        listenable: settings,
        builder: (context, _) {
          return ScheduleCard(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: Container(
                color: palette.background,
                child: Column(
                  children: [
                    MoreItemTile(
                      item: _lessons,
                      onTap: () =>
                          settings.setNotifyLessons(!settings.notifyLessons),
                      trailing: AppSwitch(
                        value: settings.notifyLessons,
                        onChanged: settings.setNotifyLessons,
                      ),
                    ),
                    if (settings.notifyLessons)
                      Padding(
                        padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 14.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'وقت التذكير قبل الحصة',
                              style: AppFonts.bodyMedium.copyWith(
                                color: palette.textSecondary,
                              ),
                            ),
                            verticalSpace(height: 8),
                            AppChoiceChips<int>(
                              items: const [
                                AppChoiceItem<int>(value: 10, label: '10 د'),
                                AppChoiceItem<int>(value: 15, label: '15 د'),
                                AppChoiceItem<int>(value: 30, label: '30 د'),
                                AppChoiceItem<int>(value: 60, label: 'ساعة'),
                              ],
                              value: settings.reminderMinutes,
                              onChanged: settings.setReminderMinutes,
                            ),
                          ],
                        ),
                      ),
                    divider(),
                    MoreItemTile(
                      item: _payments,
                      onTap: () =>
                          settings.setNotifyPayments(!settings.notifyPayments),
                      trailing: AppSwitch(
                        value: settings.notifyPayments,
                        onChanged: settings.setNotifyPayments,
                      ),
                    ),
                    divider(),
                    MoreItemTile(
                      item: _groups,
                      onTap: () =>
                          settings.setNotifyGroups(!settings.notifyGroups),
                      trailing: AppSwitch(
                        value: settings.notifyGroups,
                        onChanged: settings.setNotifyGroups,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
