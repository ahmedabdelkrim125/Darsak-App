import 'package:flutter/material.dart';
import '../../../core/const/app_assets.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/session/app_session.dart';
import '../../../core/theme/app_palette.dart';
import '../../classroom/data/classroom_store.dart';
import '../data/home_content.dart';
import '../data/home_lesson_mapper.dart';
import 'home_actions.dart';
import 'widgets/home_banner.dart';
import 'widgets/home_files_section.dart';
import 'widgets/home_header.dart';
import 'widgets/home_lessons_section.dart';
import 'widgets/home_quick_actions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final padding = MediaQuery.paddingOf(context);
    final store = ClassroomStore.instance;
    final session = AppSession.instance;

    return ColoredBox(
      color: palette.background,
      child: AdaptiveContentWrapper(
        child: ListenableBuilder(
          listenable: Listenable.merge([store, session]),
          builder: (context, _) {
            final name = session.firstName.isEmpty
                ? HomeContent.userName
                : session.firstName;

            return SingleChildScrollView(
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
                  HomeHeader(
                    name: name,
                    onNotifications: () => HomeActions.comingSoon(context),
                  ),
                  verticalSpace(height: 18),
                  const HomeBanner(
                    title: HomeContent.bannerTitle,
                    description: HomeContent.bannerDescription,
                    image: AppAssets.teacher,
                  ),
                  verticalSpace(height: 18),
                  HomeQuickActions(
                    actions: HomeContent.quickActions,
                    onSelected: (id) => HomeActions.quickAction(context, id),
                  ),
                  verticalSpace(height: 20),
                  HomeLessonsSection(
                    lessons: HomeLessonMapper.today(store, DateTime.now()),
                    onViewAll: () => HomeActions.comingSoon(context),
                    onLessonTap: (id) => HomeActions.openLesson(context, id),
                    onAddLesson: () => HomeActions.addLesson(context),
                  ),
                  verticalSpace(height: 20),
                  HomeFilesSection(
                    files: HomeContent.files,
                    onViewAll: () => HomeActions.comingSoon(context),
                    onFileTap: () => HomeActions.comingSoon(context),
                    onFileMenu: () => HomeActions.comingSoon(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
