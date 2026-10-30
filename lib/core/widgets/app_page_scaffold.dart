import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import '../helper/responsive_extension.dart';
import '../theme/app_fonts.dart';
import '../theme/app_palette.dart';
import 'app_pressable.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: AdaptiveContentWrapper(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                child: Row(
                  children: [
                    AppPressable(
                      onTap: () => Navigator.of(context).maybePop(),
                      pressedScale: 0.9,
                      child: Container(
                        width: 42.r,
                        height: 42.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: palette.surface.withValues(alpha: 0.8),
                          border: Border.all(
                            color: palette.primary.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Icon(
                          SolarIconsOutline.altArrowRight,
                          size: 22.r,
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.titleLarge.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(width: 42.r),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}