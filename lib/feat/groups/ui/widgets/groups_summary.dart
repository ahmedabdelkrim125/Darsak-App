import 'package:flutter/material.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/groups_content.dart';
import '../../data/groups_icons.dart';
import 'groups_stat_card.dart';

class GroupsSummary extends StatelessWidget {
  const GroupsSummary({
    super.key,
    required this.groups,
    required this.students,
    required this.lessons,
  });

  final int groups;
  final int students;
  final int lessons;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Expanded(
          child: GroupsStatCard(
            icon: GroupsIcons.groups,
            value: groups,
            label: GroupsContent.statGroups,
            color: palette.primary,
          ),
        ),
        horizontalSpace(width: 10),
        Expanded(
          child: GroupsStatCard(
            icon: GroupsIcons.students,
            value: students,
            label: GroupsContent.statStudents,
            color: palette.accent,
          ),
        ),
        horizontalSpace(width: 10),
        Expanded(
          child: GroupsStatCard(
            icon: GroupsIcons.lessons,
            value: lessons,
            label: GroupsContent.statLessons,
            color: const Color(0xFFB83FD6),
          ),
        ),
      ],
    );
  }
}
