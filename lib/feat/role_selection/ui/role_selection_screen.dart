import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:darsak_app/core/helper/extensions.dart';
import 'package:darsak_app/core/helper/spacing.dart';
import 'package:darsak_app/core/routing/routes.dart';
import 'package:darsak_app/core/widgets/app_button.dart';
import 'package:darsak_app/feat/role_selection/ui/widgets/role_cards.dart';
import 'package:darsak_app/feat/role_selection/ui/widgets/role_entrance.dart';
import 'package:darsak_app/feat/role_selection/ui/widgets/role_header.dart';

import '../../../core/const/user_role.dart';
import '../../../core/helper/responsive_extension.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro;
  UserRole? _selected;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  void _select(UserRole role) {
    setState(() => _selected = role);
  }

  void _continue() {
    final role = _selected;
    if (role == null) return;
    context.pushReplacementNamed(Routes.home, arguments: role);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        body: SafeArea(
          child: AdaptiveContentWrapper(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          verticalSpace(height: 24),
                          RoleEntrance(
                            animation: _intro,
                            begin: 0,
                            child: const RoleHeader(),
                          ),
                          verticalSpace(height: 28),
                          RoleEntrance(
                            animation: _intro,
                            begin: 0.25,
                            child: RoleCards(
                              selected: _selected,
                              onSelect: _select,
                            ),
                          ),
                          verticalSpace(height: 24),
                        ],
                      ),
                    ),
                  ),
                  RoleEntrance(
                    animation: _intro,
                    begin: 0.5,
                    child: AppButton(
                      label: 'متابعة',
                      expanded: true,
                      radius: 16.r,
                      onPressed: _selected == null ? null : _continue,
                    ),
                  ),
                  verticalSpace(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
