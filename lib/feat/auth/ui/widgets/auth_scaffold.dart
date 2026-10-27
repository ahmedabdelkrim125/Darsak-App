import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:darsak_app/core/theme/app_fonts.dart';
import 'package:darsak_app/core/theme/app_palette.dart';
import 'package:darsak_app/core/widgets/app_entrance.dart';
import 'package:darsak_app/core/widgets/app_pressable.dart';
import 'package:darsak_app/feat/auth/ui/widgets/auth_curved_card.dart';
import '../../../../core/const/app_assets.dart';
import '../../../../core/helper/responsive_extension.dart';

class AuthScaffold extends StatefulWidget {
  const AuthScaffold({
    super.key,
    required this.image,
    required this.child,
    this.tagline,
    this.showBack = true,
    this.onBack,
    this.imageTop,
    this.imageHeight,
    this.cardHeight,
  });

  final String image;
  final Widget child;
  final String? tagline;
  final bool showBack;
  final VoidCallback? onBack;
  final double? imageTop;
  final double? imageHeight;
  final double? cardHeight;

  @override
  State<AuthScaffold> createState() => _AuthScaffoldState();
}

class _AuthScaffoldState extends State<AuthScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final safe = MediaQuery.paddingOf(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final maxCardHeight = constraints.maxHeight - safe.top - 24.h;
            final cardHeight = min(widget.cardHeight ?? 468.h, maxCardHeight);

            return AdaptiveContentWrapper(
              child: Stack(
                children: [
                  Positioned(
                    top: widget.imageTop ?? 176.h,
                    left: 28.w,
                    right: 28.w,
                    height: widget.imageHeight ?? 200.h,
                    child: AppEntrance(
                      animation: _intro,
                      begin: 0.1,
                      child: Image.asset(
                        widget.image,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    top: safe.top + 6.h,
                    left: 0,
                    right: 0,
                    child: AppEntrance(
                      animation: _intro,
                      child: _AuthLogo(tagline: widget.tagline),
                    ),
                  ),
                  if (widget.showBack)
                    PositionedDirectional(
                      top: safe.top + 4.h,
                      start: 8.w,
                      child: _AuthBackButton(
                        onTap:
                            widget.onBack ??
                            () => Navigator.of(context).maybePop(),
                      ),
                    ),
                  Positioned(
                    left: 11.w,
                    right: 11.w,
                    bottom: safe.bottom + 12.h,
                    child: SizedBox(
                      height: cardHeight,
                      child: AppEntrance(
                        animation: _intro,
                        begin: 0.2,
                        span: 0.6,
                        from: Offset(0, 140.h),
                        child: AuthCurvedCard(child: widget.child),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuthLogo extends StatelessWidget {
  const _AuthLogo({this.tagline});

  final String? tagline;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(AppAssets.logo, height: 118.h, fit: BoxFit.contain),
        if (tagline != null)
          Text(
            tagline!,
            textAlign: TextAlign.center,
            style: AppFonts.bodySmall.copyWith(color: palette.textSecondary),
          ),
      ],
    );
  }
}

class _AuthBackButton extends StatelessWidget {
  const _AuthBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressedScale: 0.9,
      haptic: false,
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Icon(
          Icons.chevron_left_rounded,
          size: 30.r,
          color: context.palette.textPrimary,
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}
