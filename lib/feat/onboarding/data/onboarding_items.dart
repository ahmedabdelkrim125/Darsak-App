import '../../../core/const/app_assets.dart';
import 'model/onboarding_model.dart';

class OnboardingItems {
  OnboardingItems._();

  static const List<OnboardingModel> pages = [
    OnboardingModel(
      image: AppAssets.onboardingPage_1,
      title: 'نظم حصصك بسهولة',
      description: 'أدر جدولك، تابع طلابك، وكن دائماً على موعد مع النجاح.',
    ),
    OnboardingModel(
      image: AppAssets.onboardingPage_2,
      title: 'تابع جدولك بمرونة',
      description: 'أضف، عدّل، أو ألغِ الحصص بكل سهولة وفي أي وقت.',
    ),
    OnboardingModel(
      image: AppAssets.onboardingPage_3,
      title: 'ركز على ما تحب',
      description:
          'دع التنظيم للمنصة، واستمتع بوقت أكثر للتدريس، التطوير، وحياتك الشخصية.',
    ),
  ];
}
