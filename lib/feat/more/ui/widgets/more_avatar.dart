import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/more_icons.dart';

class MoreAvatar extends StatelessWidget {
  const MoreAvatar({
    super.key,
    required this.size,
    required this.path,
    required this.onTap,
  });

  final double size;
  final String? path;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.96,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AppAvatar(size: size, path: path),
          PositionedDirectional(
            bottom: -2.r,
            end: -2.r,
            child: Container(
              width: 30.r,
              height: 30.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.primary,
                border: Border.all(color: palette.background, width: 2),
              ),
              child: Icon(
                MoreIcons.camera,
                size: 15.r,
                color: palette.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
