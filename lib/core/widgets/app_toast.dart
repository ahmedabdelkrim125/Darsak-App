import 'package:flutter/material.dart';
import '../helper/responsive_extension.dart';
import '../theme/app_fonts.dart';
import '../theme/app_palette.dart';

class AppToast {
  AppToast._();

  static OverlayEntry? _entry;

  static void show(BuildContext context, String message) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    _entry?.remove();
    final entry = OverlayEntry(builder: (_) => _ToastView(message: message));
    _entry = entry;
    overlay.insert(entry);
    Future<void>.delayed(const Duration(milliseconds: 2200), () {
      if (_entry != entry) return;
      entry.remove();
      _entry = null;
    });
  }
}

class _ToastView extends StatelessWidget {
  const _ToastView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final bottom = MediaQuery.paddingOf(context).bottom + 110.h;

    return Positioned(
      left: 24.w,
      right: 24.w,
      bottom: bottom,
      child: IgnorePointer(
        child: Material(
          type: MaterialType.transparency,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 12 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: palette.strong,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppFonts.bodyMedium.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
