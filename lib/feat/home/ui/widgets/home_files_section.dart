import 'package:flutter/material.dart';
import '../../../../core/helper/spacing.dart';
import '../../data/home_content.dart';
import '../../data/home_icons.dart';
import '../../data/models/home_file_model.dart';
import 'home_file_card.dart';
import 'home_section_card.dart';

class HomeFilesSection extends StatelessWidget {
  const HomeFilesSection({
    super.key,
    required this.files,
    required this.onViewAll,
    required this.onFileTap,
    required this.onFileMenu,
  });

  final List<HomeFileModel> files;
  final VoidCallback onViewAll;
  final VoidCallback onFileTap;
  final VoidCallback onFileMenu;

  @override
  Widget build(BuildContext context) {
    return HomeSectionCard(
      title: HomeContent.filesTitle,
      icon: HomeIcons.files,
      actionLabel: HomeContent.filesAction,
      onAction: onViewAll,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < files.length; i++) ...[
            if (i > 0) horizontalSpace(width: 8),
            Expanded(
              child: HomeFileCard(
                file: files[i],
                onTap: onFileTap,
                onMenu: onFileMenu,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
