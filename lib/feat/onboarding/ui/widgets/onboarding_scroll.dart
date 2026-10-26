import 'package:flutter/widgets.dart';

class OnboardingScroll {
  const OnboardingScroll(this.controller);

  final PageController controller;

  static const double flow = 1;

  static bool reversed(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  double get page {
    if (!controller.hasClients || !controller.position.haveDimensions) {
      return controller.initialPage.toDouble();
    }
    return controller.page ?? controller.initialPage.toDouble();
  }

  int get current => page.round();

  double delta(int index) => index - page;
}
