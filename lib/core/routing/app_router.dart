import 'package:flutter/material.dart';
import 'package:darsak_app/core/routing/routes.dart';
import 'package:darsak_app/feat/auth/login/ui/login_screen.dart';
import 'package:darsak_app/feat/auth/register/ui/register_screen.dart';
import 'package:darsak_app/feat/onboarding/ui/onboarding_screen.dart';
import 'package:darsak_app/feat/role_selection/ui/role_selection_screen.dart';
import 'package:darsak_app/feat/splash/ui/splash_screen.dart';

import '../../feat/auth/forgot_password/ui/forgot_password_screen.dart';
import '../const/user_role.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
      case Routes.onboarding:
        return _fadeRoute(const OnboardingScreen(), settings);
      case Routes.roleSelection:
        return _fadeRoute(const RoleSelectionScreen(), settings);
      case Routes.login:
        return _fadeRoute(LoginScreen(role: _roleOf(settings)), settings);
      case Routes.register:
        return _fadeRoute(RegisterScreen(role: _roleOf(settings)), settings);
      case Routes.forgotPassword:
        return _fadeRoute(
          ForgotPasswordScreen(role: _roleOf(settings)),
          settings,
        );
      // case Routes.home:
      //   return _fadeRoute(const HomeScreen(), settings);
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) =>
              const Scaffold(body: Center(child: Text('الصفحة غير موجودة'))),
        );
    }
  }

  static UserRole _roleOf(RouteSettings settings) {
    final arguments = settings.arguments;
    return arguments is UserRole ? arguments : UserRole.student;
  }

  static PageRouteBuilder<void> _fadeRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder<void>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
    );
  }
}
