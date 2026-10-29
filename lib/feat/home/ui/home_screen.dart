import 'package:flutter/material.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_palette.dart';
import '../data/home_content.dart';
import 'widgets/home_banner.dart';
import 'widgets/home_files_section.dart';
import 'widgets/home_header.dart';
import 'widgets/home_lessons_section.dart';
import 'widgets/home_quick_actions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static void _todo() {}

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final padding = MediaQuery.paddingOf(context);

    return ColoredBox(
      color: palette.background,
      child: AdaptiveContentWrapper(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            16.w,
            padding.top + 12.h,
            16.w,
            padding.bottom + 110.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeHeader(onNotifications: _todo),
              verticalSpace(height: 18),
              const HomeBanner(),
              verticalSpace(height: 18),
              const HomeQuickActions(
                actions: HomeContent.quickActions,
                onTap: _todo,
              ),
              verticalSpace(height: 20),
              const HomeLessonsSection(
                lessons: HomeContent.lessons,
                onViewAll: _todo,
                onLessonTap: _todo,
              ),
              verticalSpace(height: 20),
              const HomeFilesSection(
                files: HomeContent.files,
                onViewAll: _todo,
                onFileTap: _todo,
                onFileMenu: _todo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
