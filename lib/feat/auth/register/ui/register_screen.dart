import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/const/student_grade.dart';
import '../../../../core/const/user_role.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/network/error/api_messages.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../data/repo/auth_repository.dart';
import '../../forgot_password/ui/widgets/forgot_code_step.dart';
import '../../widgets/auth_scaffold.dart';
import '../../widgets/auth_step_footer.dart';
import '../../widgets/auth_step_header.dart';
import '../../widgets/auth_step_progress.dart';
import '../../widgets/auth_step_switcher.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import '../data/register_content.dart';
import 'register_success_dialog.dart';
import 'widgets/register_identity_step.dart';
import 'widgets/register_security_step.dart';
import 'widgets/register_student_step.dart';
import 'widgets/register_teacher_step.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(getIt<AuthRepository>()),
      child: _RegisterView(role: role),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView({required this.role});

  final UserRole role;

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  static const int _stepCount = 4;
  static const int _securityStep = 2;
  static const int _codeStep = 3;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _parentPhone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  final TextEditingController _code = TextEditingController();
  StudentGrade? _grade;
  bool _terms = false;
  int _step = 0;
  bool _forward = true;

  bool get _isTeacher => widget.role == UserRole.teacher;

  @override
  void dispose() {
    _fullName.dispose();
    _username.dispose();
    _subject.dispose();
    _phone.dispose();
    _parentPhone.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _code.dispose();
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
    if (_step < _securityStep) {
      _goTo(_step + 1);
      return;
    }
    if (_step == _securityStep) {
      _submit();
      return;
    }
    _verify();
  }

  void _previous() {
    if (_step == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    FocusScope.of(context).unfocus();
    _goTo(_step - 1);
  }

  String? _nullIfEmpty(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  void _submit() {
    context.read<RegisterCubit>().submit(
      role: widget.role,
      fullName: _fullName.text,
      username: _username.text,
      email: _email.text,
      password: _password.text,
      subject: _isTeacher ? _nullIfEmpty(_subject.text) : null,
      phone: _isTeacher ? _nullIfEmpty(_phone.text) : null,
      parentPhone: _isTeacher ? null : _nullIfEmpty(_parentPhone.text),
      grade: _isTeacher ? null : _grade,
    );
  }

  void _verify() {
    context.read<RegisterCubit>().verify(email: _email.text, code: _code.text);
  }

  void _resend() {
    context.read<RegisterCubit>().resend(_email.text);
  }

  void _onState(BuildContext context, RegisterState state) {
    switch (state.status) {
      case RegisterStatus.codeSent:
        _code.clear();
        _goTo(_codeStep);
      case RegisterStatus.resent:
        AppToast.show(context, 'تم إرسال رمز جديد إلى بريدك');
      case RegisterStatus.verified:
        RegisterSuccessDialog.show(context, widget.role);
      case RegisterStatus.failure:
        final error = state.error;
        AppToast.show(context, error?.message ?? ApiMessages.unknown);
        if (error?.code == 'username_taken') _goTo(0);
        if (error?.code == 'email_exists') _goTo(1);
      default:
        break;
    }
  }

  Widget _buildStep() {
    return switch (_step) {
      0 => RegisterIdentityStep(
        fullNameController: _fullName,
        usernameController: _username,
        onSubmit: _next,
      ),
      1 =>
        _isTeacher
            ? RegisterTeacherStep(
                subjectController: _subject,
                phoneController: _phone,
                emailController: _email,
                onSubmit: _next,
              )
            : RegisterStudentStep(
                grade: _grade,
                onGradeChanged: (grade) => _grade = grade,
                parentPhoneController: _parentPhone,
                emailController: _email,
                onSubmit: _next,
              ),
      2 => RegisterSecurityStep(
        passwordController: _password,
        confirmController: _confirm,
        termsAccepted: _terms,
        onTermsChanged: (value) => _terms = value,
        onSubmit: _next,
      ),
      _ => ForgotCodeStep(
        codeController: _code,
        onSubmit: _next,
        onResend: _resend,
      ),
    };
  }

  String get _label {
    return switch (_step) {
      _securityStep => 'إنشاء الحساب',
      _codeStep => 'تأكيد الحساب',
      _ => 'التالي',
    };
  }

  @override
  Widget build(BuildContext context) {
    final content = RegisterContent.of(widget.role);

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: _onState,
      builder: (context, state) {
        return AuthScaffold(
          image: content.image,
          tagline: 'نظم وقتك .. وركز في الأهم',
          onBack: _previous,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AuthStepHeader(
                      title: content.title,
                      subtitle: content.subtitles[_step],
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
                  prompt: 'لديك حساب بالفعل؟',
                  linkLabel: 'تسجيل الدخول',
                  onLink: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
