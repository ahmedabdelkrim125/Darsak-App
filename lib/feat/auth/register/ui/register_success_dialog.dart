import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:darsak_app/core/helper/extensions.dart';
import 'package:darsak_app/core/routing/routes.dart';
import 'package:darsak_app/core/theme/app_palette.dart';
import 'package:darsak_app/feat/auth/register/data/register_success_content.dart';
import 'package:darsak_app/feat/auth/register/ui/widgets/success_card.dart';
import 'package:darsak_app/feat/auth/register/ui/widgets/success_confetti.dart';
import 'package:darsak_app/feat/auth/register/ui/widgets/success_hero.dart';

import '../../../../core/const/user_role.dart';
import '../../../../core/helper/responsive_extension.dart';

class RegisterSuccessDialog extends StatefulWidget {
  const RegisterSuccessDialog({super.key, required this.role});

  final UserRole role;

  static Future<void> show(BuildContext context, UserRole role) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'success',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return RegisterSuccessDialog(role: role);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeIn,
        );
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.12),
              end: Offset.zero,
            ).animate(curved),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1).animate(curved),
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  State<RegisterSuccessDialog> createState() => _RegisterSuccessDialogState();
}

class _RegisterSuccessDialogState extends State<RegisterSuccessDialog>
    with TickerProviderStateMixin {
  late final AnimationController _intro;
  late final AnimationController _loop;

  static const double _heroAspect = 1.49;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    _loop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
    Future<void>.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      _intro.forward();
    });
  }

  @override
  void dispose() {
    _intro.dispose();
    _loop.dispose();
    super.dispose();
  }

  void _start() {
    context.pushNamedAndRemoveUntil(
      Routes.home,
      arguments: widget.role,
      predicate: (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final content = RegisterSuccessContent.of(widget.role);

    return PopScope(
      canPop: false,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: context.adaptiveMaxContentWidth,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final heroWidth = constraints.maxWidth - 24.w;
                  final overlap = heroWidth / _heroAspect * 0.68;
                  final checkCenter = overlap + 26.h + 32.h;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 0,
                        left: 12.w,
                        right: 12.w,
                        child: SuccessHero(
                          intro: _intro,
                          loop: _loop,
                          aspectRatio: _heroAspect,
                        ),
                      ),
                      Positioned.fill(
                        child: SuccessConfetti(
                          progress: _intro,
                          originY: checkCenter,
                          colors: [
                            palette.primary,
                            palette.accent,
                            palette.success,
                            palette.primary.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: overlap),
                        child: SuccessCard(
                          intro: _intro,
                          loop: _loop,
                          content: content,
                          onStart: _start,
                        ),
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
