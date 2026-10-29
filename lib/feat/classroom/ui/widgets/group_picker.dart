import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../data/models/classroom_group.dart';
import 'classroom_chip.dart';

class GroupPicker extends StatelessWidget {
  const GroupPicker({
    super.key,
    required this.groups,
    required this.selectedId,
    required this.onChanged,
  });

  final List<ClassroomGroup> groups;
  final String? selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        for (final group in groups)
          ClassroomChip(
            label: '${group.name} · ${group.year.label}',
            selected: group.id == selectedId,
            onTap: () => onChanged(group.id),
          ),
      ],
    );
  }
}
