import 'package:flutter/material.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/groups_content.dart';

class GroupsSearchField extends StatelessWidget {
  const GroupsSearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      hintText: GroupsContent.searchHint,
      prefixIcon: Icons.search_rounded,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
    );
  }
}
