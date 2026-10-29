import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../data/models/main_tab_model.dart';
import 'widgets/main_ambient_background.dart';
import 'widgets/main_tab_placeholder.dart';
import '../../../core/const/user_role.dart';
import '../../home/ui/home_screen.dart';
import '../../schedule/ui/schedule_screen.dart';
import '../data/models/main_tabs.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.role});

  final UserRole role;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final List<MainTabModel> _tabs = MainTabs.of(widget.role);
  final Set<int> _visited = {0};
  int _index = 0;

  bool get _isTeacher => widget.role == UserRole.teacher;

  void _select(int value) {
    if (value == _index) return;
    HapticFeedback.selectionClick();
    setState(() {
      _index = value;
      _visited.add(value);
    });
  }

  Widget _pageFor(MainTabModel tab) {
    return switch (tab.id) {
      MainTabId.home when _isTeacher => const HomeScreen(),
      MainTabId.schedule when _isTeacher => const ScheduleScreen(),
      // MainTabId.groups when _isTeacher => const GroupsScreen(),
      MainTabId.home ||
      MainTabId.schedule ||
      MainTabId.groups => MainTabPlaceholder(tab: tab),
      _ => const SizedBox.expand(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = palette.background.computeLuminance() < 0.5;

    return Material(
      type: MaterialType.transparency,
      child: GlassScaffold(
        background: const MainAmbientBackground(),
        backgroundColor: palette.background,
        statusBarStyle: GlassStatusBarStyle.auto,
        body: Stack(
          children: [
            for (var i = 0; i < _tabs.length; i++)
              if (_visited.contains(i))
                Positioned.fill(
                  key: ValueKey(_tabs[i].id),
                  child: _MainPage(
                    selected: i == _index,
                    child: _pageFor(_tabs[i]),
                  ),
                ),
          ],
        ),
        bottomBar: GlassTabBar.bottom(
          selectedIndex: _index,
          onTabSelected: _select,
          settings: isDark
              ? LiquidGlassSettings.ios27Dark
              : LiquidGlassSettings.ios27Light,
          indicatorColor: palette.primary.withValues(
            alpha: isDark ? 0.30 : 0.16,
          ),
          selectedIconColor: palette.primary,
          selectedLabelColor: palette.primary,
          unselectedIconColor: palette.textPrimary,
          unselectedLabelColor: palette.textPrimary,
          textStyle: const TextStyle(
            fontFamily: AppFonts.primary,
            fontSize: 11,
            height: 1.2,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none,
          ),
          tabs: [
            for (final tab in _tabs)
              GlassTab(
                icon: Icon(tab.icon),
                activeIcon: Icon(tab.activeIcon),
                label: tab.label,
              ),
          ],
        ),
      ),
    );
  }
}

class _MainPage extends StatelessWidget {
  const _MainPage({required this.selected, required this.child});

  final bool selected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: selected ? 1 : 0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: TickerMode(
        enabled: selected,
        child: IgnorePointer(ignoring: !selected, child: child),
      ),
    );
  }
}