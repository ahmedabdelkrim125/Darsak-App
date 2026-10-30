import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/helper/extensions.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/app_palette.dart';
import 'widgets/splash_background.dart';
import 'widgets/splash_logo.dart';
import 'widgets/splash_orbit.dart';
import 'widgets/splash_progress.dart';
import 'widgets/splash_ripples.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _intro;
  late final AnimationController _loop;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _loop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
    _intro.forward().whenComplete(_goNext);
  }

  Future<void> _goNext() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    context.pushReplacementNamed(Routes.onboarding);
  }

  @override
  void dispose() {
    _intro.dispose();
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: context.palette.background,
        body: Stack(
          fit: StackFit.expand,
          children: [
            SplashBackground(intro: _intro, loop: _loop),
            SplashRipples(intro: _intro, loop: _loop),
            SplashOrbit(intro: _intro),
            Center(
              child: SplashLogo(intro: _intro, loop: _loop),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SplashProgress(intro: _intro),
            ),
          ],
        ),
      ),
    );
  }
}