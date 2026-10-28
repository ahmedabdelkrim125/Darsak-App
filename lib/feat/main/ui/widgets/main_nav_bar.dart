import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_glass.dart';
import '../../data/models/main_tab_model.dart';
import '../../../../core/helper/responsive_extension.dart';
import 'main_nav_item.dart';

class MainNavBar extends StatelessWidget {
  const MainNavBar({
    super.key,
    required this.tabs,
    required this.index,
    required this.onChanged,
  });

  final List<MainTabModel> tabs;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = palette.background.computeLuminance() < 0.5;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final barHeight = 68.h;

    return Align(
      alignment: Alignment.bottomCenter,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.adaptiveMaxContentWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, safeBottom + 12.h),
          child: AppGlass(
            radius: barHeight / 2,
            child: SizedBox(
              height: barHeight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final slot = width / tabs.length;
                  final bubbleWidth = slot - 6.w;
                  final bubbleHeight = barHeight - 10.h;
                  final travel = (width - bubbleWidth) / 2;
                  final x = travel <= 0
                      ? 0.0
                      : (slot * (index + 0.5) - width / 2) / travel;

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      AnimatedAlign(
                        alignment: AlignmentDirectional(x, 0),
                        duration: const Duration(milliseconds: 450),
                        curve: Curves.easeOutBack,
                        child: Container(
                          width: bubbleWidth,
                          height: bubbleHeight,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: isDark ? 0.10 : 0.7,
                            ),
                            borderRadius: BorderRadius.circular(
                              bubbleHeight / 2,
                            ),
                            border: Border.all(
                              color: palette.primary.withValues(alpha: 0.14),
                              width: 1.2,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          for (var i = 0; i < tabs.length; i++)
                            Expanded(
                              child: MainNavItem(
                                tab: tabs[i],
                                selected: i == index,
                                onTap: () => onChanged(i),
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
