import 'package:solar_icons/solar_icons.dart';
import 'main_tab_model.dart';

import '../../../../core/const/user_role.dart';

class MainTabs {
  MainTabs._();

  static const _home = MainTabModel(
    id: MainTabId.home,
    label: 'الرئيسية',
    icon: SolarIconsOutline.home,
    activeIcon: SolarIconsBold.home,
  );

  static const _more = MainTabModel(
    id: MainTabId.more,
    label: 'المزيد',
    icon: SolarIconsOutline.menuDots,
    activeIcon: SolarIconsBold.menuDots,
  );

  static List<MainTabModel> of(UserRole role) {
    return switch (role) {
      UserRole.teacher => const [
        _home,
        MainTabModel(
          id: MainTabId.schedule,
          label: 'الجدول',
          icon: SolarIconsOutline.calendar,
          activeIcon: SolarIconsBold.calendar,
        ),
        MainTabModel(
          id: MainTabId.groups,
          label: 'المجموعات',
          icon: SolarIconsOutline.usersGroupRounded,
          activeIcon: SolarIconsBold.usersGroupRounded,
        ),
        MainTabModel(
          id: MainTabId.payments,
          label: 'المدفوعات',
          icon: SolarIconsOutline.wallet,
          activeIcon: SolarIconsBold.wallet,
        ),
        _more,
      ],
      UserRole.student => const [
        _home,
        MainTabModel(
          id: MainTabId.schedule,
          label: 'جدولي',
          icon: SolarIconsOutline.calendar,
          activeIcon: SolarIconsBold.calendar,
        ),
        MainTabModel(
          id: MainTabId.groups,
          label: 'مجموعاتي',
          icon: SolarIconsOutline.usersGroupRounded,
          activeIcon: SolarIconsBold.usersGroupRounded,
        ),
        _more,
      ],
    };
  }
}
