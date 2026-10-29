import 'package:flutter/material.dart';
import '../../../../core/helper/extensions.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/session/app_session.dart';
import '../../widgets/auth_scaffold.dart';
import '../data/login_content.dart';
import 'widgets/login_actions.dart';
import 'widgets/login_fields.dart';
import 'widgets/login_header.dart';
import 'widgets/login_options.dart';
import '../../../../core/const/user_role.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.role});

  final UserRole role;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _remember = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    AppSession.instance.signIn(role: widget.role);
    context.pushReplacementNamed(Routes.home, arguments: widget.role);
  }

  void _openRegister() {
    context.pushNamed(Routes.register, arguments: widget.role);
  }

  void _openForgotPassword() {
    context.pushNamed(Routes.forgotPassword, arguments: widget.role);
  }

  @override
  Widget build(BuildContext context) {
    final content = LoginContent.of(widget.role);

    return AuthScaffold(
      image: content.image,
      tagline: 'نظم وقتك .. وركز في الأهم',
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoginHeader(description: content.description),
                verticalSpace(height: 8),
                LoginFields(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  onSubmit: _submit,
                ),
                LoginOptions(
                  remember: _remember,
                  onRememberChanged: (value) =>
                      setState(() => _remember = value),
                  onForgotPassword: _openForgotPassword,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                verticalSpace(height: 10),
                LoginActions(onLogin: _submit, onCreateAccount: _openRegister),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
