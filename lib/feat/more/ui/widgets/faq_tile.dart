import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/more_faq.dart';
import '../../data/more_icons.dart';

class FaqTile extends StatefulWidget {
  const FaqTile({super.key, required this.item});

  final FaqItem item;

  @override
  State<FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<FaqTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppPressable(
      onTap: () => setState(() => _open = !_open),
      pressedScale: 0.99,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: palette.background,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: palette.primary.withValues(alpha: 0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.item.question,
                    style: AppFonts.titleMedium.copyWith(
                      color: palette.textPrimary,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                horizontalSpace(width: 8),
                AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    MoreIcons.chevronDown,
                    size: 20.r,
                    color: palette.primary,
                  ),
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: _open
                  ? Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text(
                        widget.item.answer,
                        style: AppFonts.bodyMedium.copyWith(
                          color: palette.textSecondary,
                          fontSize: 13.sp,
                          height: 1.6,
                        ),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
