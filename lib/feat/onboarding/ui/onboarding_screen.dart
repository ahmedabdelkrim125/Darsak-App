import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:darsak_app/core/helper/extensions.dart';
import 'package:darsak_app/core/helper/spacing.dart';
import 'package:darsak_app/core/routing/routes.dart';
import 'package:darsak_app/feat/onboarding/data/onboarding_items.dart';
import 'package:darsak_app/feat/onboarding/ui/widgets/onboarding_actions.dart';
import 'package:darsak_app/feat/onboarding/ui/widgets/onboarding_page.dart';
import 'package:darsak_app/feat/onboarding/ui/widgets/onboarding_scroll.dart';
import 'package:darsak_app/feat/onboarding/ui/widgets/onboarding_skip.dart';
import 'package:darsak_app/feat/onboarding/ui/widgets/onboarding_stage.dart';

import '../../../core/helper/responsive_extension.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final OnboardingScroll _scroll;
  late final AnimationController _intro;
  late final AnimationController _loop;

  static const _pages = OnboardingItems.pages;
  static final List<String> _images = [for (final page in _pages) page.image];
  static const Duration _pageDuration = Duration(milliseconds: 900);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _scroll = OnboardingScroll(_pageController);
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
    _loop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final image in _images) {
      precacheImage(AssetImage(image), context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _intro.dispose();
    _loop.dispose();
    super.dispose();
  }

  void _next() {
    if (_scroll.current >= _pages.length - 1) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: _pageDuration,
      curve: Curves.easeInOutCubicEmphasized,
    );
  }

  void _back() {
    if (_scroll.current <= 0) return;
    _pageController.previousPage(
      duration: _pageDuration,
      curve: Curves.easeInOutCubicEmphasized,
    );
  }

  void _finish() {
    context.pushReplacementNamed(Routes.roleSelection);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textsHeight = 210.h;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        body: SafeArea(
          child: AdaptiveContentWrapper(
            child: Column(
              children: [
                OnboardingSkip(intro: _intro, onSkip: _finish),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: textsHeight + 12.h,
                        child: IgnorePointer(
                          child: OnboardingStage(
                            images: _images,
                            scroll: _scroll,
                            intro: _intro,
                            loop: _loop,
                          ),
                        ),
                      ),
                      PageView.builder(
                        controller: _pageController,
                        reverse: OnboardingScroll.reversed(context),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _pages.length,
                        itemBuilder: (context, index) {
                          return OnboardingPage(
                            index: index,
                            item: _pages[index],
                            scroll: _scroll,
                            intro: _intro,
                            textsHeight: textsHeight,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                verticalSpace(height: 20),
                OnboardingActions(
                  count: _pages.length,
                  scroll: _scroll,
                  intro: _intro,
                  onNext: _next,
                  onBack: _back,
                ),
                verticalSpace(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
