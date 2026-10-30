import 'package:flutter/material.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/session/app_session.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../classroom/data/classroom_store.dart';
import '../../groups/data/groups_icons.dart';
import '../../groups/ui/widgets/groups_stat_card.dart';
import '../../schedule/ui/widgets/schedule_card.dart';
import '../data/more_icons.dart';
import 'edit_profile_screen.dart';
import 'more_navigator.dart';
import '../../../core/widgets/app_page_scaffold.dart';

class PublicProfileScreen extends StatelessWidget {
  const PublicProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final session = AppSession.instance;
    final store = ClassroomStore.instance;

    return AppPageScaffold(
      title: 'الملف العام للمعلم',
      child: ListenableBuilder(
        listenable: Listenable.merge([session, store]),
        builder: (context, _) {
          final years = <String>{
            for (final group in store.groups) group.year.label,
          };
          final name = session.fullName.isEmpty
              ? 'معلم درسّك'
              : session.fullName;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: palette.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Icon(MoreIcons.preview, size: 20.r, color: palette.primary),
                    horizontalSpace(width: 8),
                    Expanded(
                      child: Text(
                        'هكذا يظهر ملفك للطلاب',
                        style: AppFonts.bodyMedium.copyWith(
                          color: palette.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpace(height: 14),
              ScheduleCard(
                child: Column(
                  children: [
                    verticalSpace(height: 6),
                    AppAvatar(size: 100.r, path: session.avatarPath),
                    verticalSpace(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFonts.titleLarge.copyWith(
                              color: palette.textPrimary,
                            ),
                          ),
                        ),
                        if (session.isVerified) ...[
                          horizontalSpace(width: 6),
                          Icon(
                            MoreIcons.verifiedBadge,
                            size: 22.r,
                            color: palette.primary,
                          ),
                        ],
                      ],
                    ),
                    verticalSpace(height: 4),
                    Text(
                      session.subject.isEmpty
                          ? 'معلم'
                          : 'معلم ${session.subject}',
                      style: AppFonts.bodyMedium.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    verticalSpace(height: 12),
                    if (session.bio.isEmpty)
                      AppPressable(
                        onTap: () => MoreNavigator.push(
                          context,
                          const EditProfileScreen(),
                        ),
                        pressedScale: 0.96,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: palette.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Text(
                            'أضف نبذة عنك',
                            style: AppFonts.labelMedium.copyWith(
                              color: palette.primary,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      )
                    else
                      Text(
                        session.bio,
                        textAlign: TextAlign.center,
                        style: AppFonts.bodyMedium.copyWith(
                          color: palette.textPrimary,
                          height: 1.6,
                        ),
                      ),
                    verticalSpace(height: 6),
                  ],
                ),
              ),
              verticalSpace(height: 14),
              Row(
                children: [
                  Expanded(
                    child: GroupsStatCard(
                      icon: GroupsIcons.groups,
                      value: store.groups.length,
                      label: 'مجموعات',
                      color: palette.primary,
                    ),
                  ),
                  horizontalSpace(width: 10),
                  Expanded(
                    child: GroupsStatCard(
                      icon: GroupsIcons.students,
                      value: store.studentsTotal,
                      label: 'طلاب',
                      color: palette.accent,
                    ),
                  ),
                  horizontalSpace(width: 10),
                  Expanded(
                    child: GroupsStatCard(
                      icon: GroupsIcons.lessons,
                      value: store.weeklyLessonsCount,
                      label: 'حصص أسبوعياً',
                      color: const Color(0xFFB83FD6),
                    ),
                  ),
                ],
              ),
              verticalSpace(height: 14),
              ScheduleCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'المراحل الدراسية',
                      style: AppFonts.titleMedium.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                    verticalSpace(height: 10),
                    if (years.isEmpty)
                      Text(
                        'لم تضف مجموعات بعد',
                        style: AppFonts.bodyMedium.copyWith(
                          color: palette.textSecondary,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          for (final year in years)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: palette.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                year,
                                style: AppFonts.bodySmall.copyWith(
                                  color: palette.primary,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
