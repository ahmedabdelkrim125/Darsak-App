import 'package:flutter/material.dart';
import 'onboarding_scroll.dart';
import 'onboarding_texts.dart';

import '../../data/model/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.index,
    required this.item,
    required this.scroll,
    required this.intro,
    required this.textsHeight,
  });

  final int index;
  final OnboardingModel item;
  final OnboardingScroll scroll;
  final Animation<double> intro;
  final double textsHeight;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: textsHeight,
        child: OnboardingTexts(
          index: index,
          title: item.title,
          description: item.description,
          scroll: scroll,
          intro: intro,
        ),
      ),
    );
  }
}
