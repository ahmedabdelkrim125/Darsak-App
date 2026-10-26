import 'package:flutter/material.dart';
import 'package:darsak_app/core/widgets/app_button_style.dart';
import 'package:darsak_app/core/widgets/app_icon_button.dart';

class OnboardingNavButton extends StatefulWidget {
  const OnboardingNavButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.size,
    this.iconSize,
    this.variant = AppButtonVariant.soft,
    this.visible = true,
    this.pulse = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final double? iconSize;
  final AppButtonVariant variant;
  final bool visible;
  final bool pulse;

  @override
  State<OnboardingNavButton> createState() => _OnboardingNavButtonState();
}

class _OnboardingNavButtonState extends State<OnboardingNavButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    if (widget.pulse) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant OnboardingNavButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulse && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.pulse && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppButtonPalette.of(context, widget.variant);
    final haloColor = palette.color ?? palette.foreground;

    return IgnorePointer(
      ignoring: !widget.visible,
      child: AnimatedScale(
        scale: widget.visible ? 1 : 0,
        duration: const Duration(milliseconds: 350),
        curve: widget.visible ? Curves.easeOutBack : Curves.easeIn,
        child: AnimatedOpacity(
          opacity: widget.visible ? 1 : 0,
          duration: const Duration(milliseconds: 250),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              if (widget.pulse)
                Positioned.fill(
                  child: IgnorePointer(
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      maxHeight: double.infinity,
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          final t = Curves.easeOut.transform(_controller.value);
                          final haloSize = widget.size * (1 + 0.55 * t);
                          return Container(
                            width: haloSize,
                            height: haloSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: haloColor.withValues(
                                  alpha: 0.45 * (1 - t),
                                ),
                                width: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              AppIconButton(
                icon: widget.icon,
                onPressed: widget.onPressed,
                variant: widget.variant,
                size: widget.size,
                iconSize: widget.iconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
