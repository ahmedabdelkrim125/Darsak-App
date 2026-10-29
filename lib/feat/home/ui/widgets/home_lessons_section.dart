import 'package:flutter/material.dart';
import '../../../../core/helper/spacing.dart';
import '../../data/home_content.dart';
import '../../data/home_icons.dart';
import '../../data/models/home_lesson_model.dart';
import 'home_lesson_tile.dart';
import 'home_lessons_empty.dart';
import 'home_section_card.dart';

class HomeLessonsSection extends StatelessWidget {
  const HomeLessonsSection({
    super.key,
    required this.lessons,
    required this.onViewAll,
    required this.onLessonTap,
    required this.onAddLesson,
  });

  final List<HomeLessonModel> lessons;
  final VoidCallback onViewAll;
  final ValueChanged<String> onLessonTap;
  final VoidCallback onAddLesson;

  @override
  Widget build(BuildContext context) {
    return HomeSectionCard(
      title: HomeContent.lessonsTitle,
      icon: HomeIcons.schedule,
      actionLabel: HomeContent.lessonsAction,
      onAction: onViewAll,
      child: lessons.isEmpty
          ? HomeLessonsEmpty(onAdd: onAddLesson)
          : Column(
              children: [
                for (var i = 0; i < lessons.length; i++) ...[
                  if (i > 0) verticalSpace(height: 10),
                  HomeLessonTile(
                    lesson: lessons[i],
                    onTap: () => onLessonTap(lessons[i].id),
                  ),
                ],
              ],
            ),
    );
  }
}
