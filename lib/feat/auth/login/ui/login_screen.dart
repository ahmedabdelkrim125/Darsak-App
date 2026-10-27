import 'package:flutter/material.dart';
import 'package:darsak_app/core/helper/extensions.dart';
import 'package:darsak_app/core/helper/spacing.dart';
import 'package:darsak_app/core/routing/routes.dart';
import 'package:darsak_app/feat/auth/login/data/login_content.dart';
import 'package:darsak_app/feat/auth/login/ui/widgets/login_actions.dart';
import 'package:darsak_app/feat/auth/login/ui/widgets/login_fields.dart';
import 'package:darsak_app/feat/auth/login/ui/widgets/login_header.dart';
import 'package:darsak_app/feat/auth/login/ui/widgets/login_options.dart';
import 'package:darsak_app/feat/auth/ui/widgets/auth_scaffold.dart';
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
    context.pushReplacementNamed(Routes.home, arguments: widget.role);
  }

  void _openRegister() {
    context.pushNamed(Routes.register, arguments: widget.role);
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
                  onForgotPassword: () {},
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
