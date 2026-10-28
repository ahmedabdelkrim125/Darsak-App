import 'package:flutter/material.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/models/main_tab_model.dart';
import '../../../../core/helper/responsive_extension.dart';

class MainTabPlaceholder extends StatelessWidget {
  const MainTabPlaceholder({super.key, required this.tab});

  final MainTabModel tab;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final padding = MediaQuery.paddingOf(context);
    final colors = [palette.primary, palette.accent, palette.strong];

    return AdaptiveContentWrapper(
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          20.w,
          padding.top + 24.h,
          20.w,
          padding.bottom + 16.h,
        ),
        itemCount: 9,
        separatorBuilder: (context, index) => verticalSpace(height: 14),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tab.label,
                  style: AppFonts.headlineLarge.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                verticalSpace(height: 4),
                Text(
                  'هذه الصفحة قيد التنفيذ',
                  style: AppFonts.bodyMedium.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ],
            );
          }

          return Container(
            height: 96.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: colors[index % colors.length].withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Icon(tab.activeIcon, size: 30.r, color: Colors.white),
                SizedBox(width: 14.w),
                Text(
                  'محتوى تجريبي $index',
                  style: AppFonts.titleMedium.copyWith(color: Colors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
