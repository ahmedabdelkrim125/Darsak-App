import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/helper/spacing.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_entrance.dart';
import '../../../../../core/helper/responsive_extension.dart';
import '../../../../../core/widgets/app_success_check.dart';

class ForgotSuccessView extends StatefulWidget {
  const ForgotSuccessView({super.key, required this.onLogin});

  final VoidCallback onLogin;

  @override
  State<ForgotSuccessView> createState() => _ForgotSuccessViewState();
}

class _ForgotSuccessViewState extends State<ForgotSuccessView>
    with TickerProviderStateMixin {
  late final AnimationController _intro;
  late final AnimationController _loop;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();
    _loop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
    Future<void>.delayed(const Duration(milliseconds: 200), () {
      if (mounted) HapticFeedback.mediumImpact();
    });
  }

  @override
  void dispose() {
    _intro.dispose();
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppSuccessCheck(intro: _intro, loop: _loop, size: 76.h),
        verticalSpace(height: 18),
        AppEntrance(
          animation: _intro,
          begin: 0.45,
          span: 0.25,
          child: Text(
            'تم تغيير كلمة المرور!',
            textAlign: TextAlign.center,
            style: AppFonts.headlineMedium.copyWith(color: palette.textPrimary),
          ),
        ),
        verticalSpace(height: 8),
        AppEntrance(
          animation: _intro,
          begin: 0.55,
          span: 0.25,
          child: Text(
            'يمكنك الآن تسجيل الدخول\nبكلمة مرورك الجديدة',
            textAlign: TextAlign.center,
            style: AppFonts.bodyMedium.copyWith(color: palette.textSecondary),
          ),
        ),
        verticalSpace(height: 24),
        AppEntrance(
          animation: _intro,
          begin: 0.65,
          span: 0.3,
          child: AppButton(
            label: 'تسجيل الدخول',
            expanded: true,
            radius: 16.r,
            height: 52.h,
            onPressed: widget.onLogin,
          ),
        ),
      ],
    );
  }
}
