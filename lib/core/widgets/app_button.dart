import 'dart:math';
import 'package:flutter/material.dart';
import 'package:darsak_app/core/theme/app_fonts.dart';
import 'package:darsak_app/core/widgets/app_button_style.dart';
import 'package:darsak_app/core/widgets/app_pressable.dart';

import '../helper/responsive_extension.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.iconPosition = AppButtonIconPosition.end,
    this.variant = AppButtonVariant.primary,
    this.width,
    this.height,
    this.radius,
    this.expanded = false,
    this.isLoading = false,
    this.shimmer = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonIconPosition iconPosition;
  final AppButtonVariant variant;
  final double? width;
  final double? height;
  final double? radius;
  final bool expanded;
  final bool isLoading;
  final bool shimmer;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const Interval _sweep = Interval(0, 0.4, curve: Curves.easeInOut);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppButtonPalette.of(context, widget.variant);
    final height = widget.height ?? 56.h;
    final borderRadius = BorderRadius.circular(widget.radius ?? height / 2);
    final interactive = widget.onPressed != null && !widget.isLoading;
    final effects = widget.shimmer && interactive;

    return AppPressable(
      onTap: interactive ? widget.onPressed : null,
      child: AnimatedOpacity(
        opacity: widget.onPressed == null ? 0.5 : 1,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: widget.expanded ? double.infinity : widget.width,
          height: height,
          decoration: BoxDecoration(
            color: palette.color,
            border: palette.border,
            borderRadius: borderRadius,
            boxShadow: palette.shadows,
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (effects)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: AlignmentDirectional.centerStart,
                                end: AlignmentDirectional.centerEnd,
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withValues(alpha: 0.35),
                                  Colors.transparent,
                                ],
                                stops: const [0.35, 0.5, 0.65],
                                transform: _SweepTransform(
                                  _sweep.transform(_controller.value),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: _buildContent(palette, effects),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AppButtonPalette palette, bool effects) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutBack,
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: widget.isLoading
          ? SizedBox(
              key: const ValueKey('loading'),
              width: 24.r,
              height: 24.r,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: palette.foreground,
              ),
            )
          : AnimatedBuilder(
              key: const ValueKey('content'),
              animation: _controller,
              builder: (context, _) => _buildRow(palette, effects),
            ),
    );
  }

  Widget _buildRow(AppButtonPalette palette, bool effects) {
    final style = AppFonts.titleMedium.copyWith(color: palette.foreground);
    final sign = Directionality.of(context) == TextDirection.rtl ? -1.0 : 1.0;
    final icon = widget.icon;
    final atStart = widget.iconPosition == AppButtonIconPosition.start;

    final label = AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.6),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Text(widget.label, key: ValueKey(widget.label), style: style),
    );

    Widget? iconWidget;
    if (icon != null) {
      final nudge = effects && !atStart
          ? sin(_controller.value * 2 * pi) * 3.w * sign
          : 0.0;
      iconWidget = Transform.translate(
        offset: Offset(nudge, 0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Icon(
            icon,
            key: ValueKey(icon),
            size: 22.r,
            color: palette.foreground,
          ),
        ),
      );
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconWidget != null && atStart) ...[
            iconWidget,
            SizedBox(width: 10.w),
          ],
          label,
          if (iconWidget != null && !atStart) ...[
            SizedBox(width: 10.w),
            iconWidget,
          ],
        ],
      ),
    );
  }
}

class _SweepTransform extends GradientTransform {
  const _SweepTransform(this.percent);

  final double percent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final sign = textDirection == TextDirection.rtl ? -1.0 : 1.0;
    return Matrix4.translationValues(
      bounds.width * (percent * 2 - 1) * sign,
      0,
      0,
    );
  }
}
