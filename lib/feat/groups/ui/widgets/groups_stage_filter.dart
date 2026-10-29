import 'package:flutter/material.dart';
import '../../../../core/const/student_grade.dart';
import '../../../../core/helper/spacing.dart';
import '../../../classroom/ui/widgets/classroom_chip.dart';
import '../../data/groups_content.dart';

class GroupsStageFilter extends StatelessWidget {
  const GroupsStageFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final StudentGrade? selected;
  final ValueChanged<StudentGrade?> onChanged;

  @override
  Widget build(BuildContext context) {
    final stages = <StudentGrade?>[null, ...StudentGrade.values];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var i = 0; i < stages.length; i++) ...[
            if (i > 0) horizontalSpace(width: 8),
            ClassroomChip(
              label: stages[i]?.label ?? GroupsContent.all,
              selected: stages[i] == selected,
              onTap: () => onChanged(stages[i]),
            ),
          ],
        ],
      ),
    );
  }
}
