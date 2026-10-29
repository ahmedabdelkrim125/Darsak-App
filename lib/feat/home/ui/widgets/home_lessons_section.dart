import 'package:flutter/material.dart';
import '../../../../core/helper/spacing.dart';
import '../../data/home_content.dart';
import '../../data/home_icons.dart';
import '../../data/models/home_lesson_model.dart';
import 'home_lesson_tile.dart';
import 'home_section_card.dart';

class HomeLessonsSection extends StatelessWidget {
  const HomeLessonsSection({
    super.key,
    required this.lessons,
    required this.onViewAll,
    required this.onLessonTap,
  });

  final List<HomeLessonModel> lessons;
  final VoidCallback onViewAll;
  final VoidCallback onLessonTap;

  @override
  Widget build(BuildContext context) {
    return HomeSectionCard(
      title: HomeContent.lessonsTitle,
      icon: HomeIcons.schedule,
      actionLabel: HomeContent.lessonsAction,
      onAction: onViewAll,
      child: Column(
        children: [
          for (var i = 0; i < lessons.length; i++) ...[
            if (i > 0) verticalSpace(height: 10),
            HomeLessonTile(lesson: lessons[i], onTap: onLessonTap),
          ],
        ],
      ),
    );
  }
}
