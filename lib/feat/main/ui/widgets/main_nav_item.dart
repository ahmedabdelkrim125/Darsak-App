import 'package:flutter/material.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/models/main_tab_model.dart';
import '../../../../core/helper/responsive_extension.dart';

class MainNavItem extends StatelessWidget {
  const MainNavItem({
    super.key,
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final MainTabModel tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = selected
        ? palette.primary
        : palette.textPrimary.withValues(alpha: 0.78);

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.92,
      haptic: false,
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: selected ? 1.1 : 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Icon(
                  selected ? tab.activeIcon : tab.icon,
                  key: ValueKey(selected),
                  size: 26.r,
                  color: color,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: AppFonts.bodySmall.copyWith(
                fontSize: 11.sp,
                height: 1.2,
                color: color,
                fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
              ),
              child: Text(
                tab.label,
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
