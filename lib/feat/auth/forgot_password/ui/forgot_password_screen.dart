import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/const/user_role.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/network/error/api_messages.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../data/repo/auth_repository.dart';
import '../../widgets/auth_scaffold.dart';
import '../../widgets/auth_step_footer.dart';
import '../../widgets/auth_step_header.dart';
import '../../widgets/auth_step_progress.dart';
import '../../widgets/auth_step_switcher.dart';
import '../cubit/forgot_password_cubit.dart';
import '../cubit/forgot_password_state.dart';
import '../data/forgot_password_content.dart';
import 'widgets/forgot_code_step.dart';
import 'widgets/forgot_email_step.dart';
import 'widgets/forgot_password_step.dart';
import 'widgets/forgot_success_view.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(getIt<AuthRepository>()),
      child: _ForgotPasswordView(role: role),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView({required this.role});

  final UserRole role;

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  static const int _stepCount = 3;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _code = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  int _step = 0;
  bool _forward = true;
  bool _done = false;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _goTo(int step) {
    setState(() {
      _forward = step > _step;
      _step = step;
    });
  }

  void _next() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final cubit = context.read<ForgotPasswordCubit>();
    switch (_step) {
      case 0:
        cubit.sendCode(_email.text);
      case 1:
        cubit.verify(email: _email.text, code: _code.text);
      default:
        cubit.resetPassword(_password.text);
    }
  }

  void _resend() {
    context.read<ForgotPasswordCubit>().resend(_email.text);
  }

  void _previous() {
    if (_step == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    FocusScope.of(context).unfocus();
    _goTo(_step - 1);
  }

  void _backToLogin() {
    Navigator.of(context).popUntil(ModalRoute.withName(Routes.login));
  }

  void _onState(BuildContext context, ForgotPasswordState state) {
    switch (state.status) {
      case ForgotPasswordStatus.codeSent:
        _code.clear();
        _goTo(1);
      case ForgotPasswordStatus.resent:
        AppToast.show(context, 'تم إرسال رمز جديد إلى بريدك');
      case ForgotPasswordStatus.codeVerified:
        _goTo(2);
      case ForgotPasswordStatus.done:
        setState(() => _done = true);
      case ForgotPasswordStatus.failure:
        AppToast.show(context, state.error?.message ?? ApiMessages.unknown);
      default:
        break;
    }
  }

  String get _label {
    return switch (_step) {
      0 => 'إرسال الرمز',
      1 => 'تأكيد الرمز',
      _ => 'تغيير كلمة المرور',
    };
  }

  Widget _buildStep() {
    return switch (_step) {
      0 => ForgotEmailStep(emailController: _email, onSubmit: _next),
      1 => ForgotCodeStep(
        codeController: _code,
        onSubmit: _next,
        onResend: _resend,
      ),
      _ => ForgotPasswordStep(
        passwordController: _password,
        confirmController: _confirm,
        onSubmit: _next,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final content = ForgotPasswordContent.of(widget.role);

    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: _onState,
      builder: (context, state) {
        return PopScope(
          canPop: !_done,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) _backToLogin();
          },
          child: AuthScaffold(
            image: content.image,
            tagline: 'نظم وقتك .. وركز في الأهم',
            showBack: !_done,
            onBack: _previous,
            child: _done
                ? ForgotSuccessView(onLogin: _backToLogin)
                : Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AuthStepHeader(
                              title: ForgotPasswordContent.titles[_step],
                              subtitle: content.subtitle(_step, _email.text),
                            ),
                            verticalSpace(height: 8),
                            AuthStepProgress(count: _stepCount, step: _step),
                            verticalSpace(height: 10),
                            AuthStepSwitcher(
                              step: _step,
                              forward: _forward,
                              child: _buildStep(),
                            ),
                          ],
                        ),
                        AuthStepFooter(
                          label: _label,
                          onPressed: _next,
                          isLoading: state.isBusy,
                          prompt: 'تذكرت كلمة المرور؟',
                          linkLabel: 'تسجيل الدخول',
                          onLink: () => Navigator.of(context).maybePop(),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
