import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/const/user_role.dart';
import '../../../../core/cubit/request_state.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/helper/extensions.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/network/error/api_messages.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../data/repo/auth_repository.dart';
import '../../widgets/auth_scaffold.dart';
import '../cubit/login_cubit.dart';
import '../data/login_content.dart';
import 'widgets/login_actions.dart';
import 'widgets/login_fields.dart';
import 'widgets/login_header.dart';
import 'widgets/login_options.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(getIt<AuthRepository>()),
      child: _LoginView(role: role),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView({required this.role});

  final UserRole role;

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
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
    context.read<LoginCubit>().login(
      email: _emailController.text,
      password: _passwordController.text,
      role: widget.role,
    );
  }

  void _onState(BuildContext context, RequestState<UserRole> state) {
    if (state.isSuccess) {
      context.pushReplacementNamed(Routes.home, arguments: widget.role);
    } else if (state.isFailure) {
      AppToast.show(context, state.error?.message ?? ApiMessages.unknown);
    }
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

    return BlocConsumer<LoginCubit, RequestState<UserRole>>(
      listener: _onState,
      builder: (context, state) {
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
                    LoginActions(
                      onLogin: _submit,
                      onCreateAccount: _openRegister,
                      isLoading: state.isLoading,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
