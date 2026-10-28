import 'package:flutter/material.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/const/user_role.dart';
import '../data/forgot_password_content.dart';
import 'widgets/forgot_code_step.dart';
import 'widgets/forgot_email_step.dart';
import 'widgets/forgot_password_step.dart';
import 'widgets/forgot_success_view.dart';
import '../../ui/widgets/auth_scaffold.dart';
import '../../ui/widgets/auth_step_footer.dart';
import '../../ui/widgets/auth_step_header.dart';
import '../../ui/widgets/auth_step_progress.dart';
import '../../ui/widgets/auth_step_switcher.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, required this.role});

  final UserRole role;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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

  void _next() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_step < _stepCount - 1) {
      setState(() {
        _forward = true;
        _step++;
      });
      return;
    }
    setState(() => _done = true);
  }

  void _previous() {
    if (_step == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _forward = false;
      _step--;
    });
  }

  void _backToLogin() {
    Navigator.of(context).popUntil(ModalRoute.withName(Routes.login));
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
        onResend: () {},
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
                      prompt: 'تذكرت كلمة المرور؟',
                      linkLabel: 'تسجيل الدخول',
                      onLink: () => Navigator.of(context).maybePop(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
