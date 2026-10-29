import 'package:flutter/material.dart';
import '../helper/responsive_extension.dart';
import '../helper/spacing.dart';
import '../theme/app_fonts.dart';
import '../theme/app_palette.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (_) => AppBottomSheet(title: title, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: BoxDecoration(
          color: palette.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: palette.textSecondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                verticalSpace(height: 14),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppFonts.titleLarge.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                verticalSpace(height: 18),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
