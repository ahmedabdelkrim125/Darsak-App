import 'package:flutter/material.dart';
import 'package:darsak_app/core/helper/spacing.dart';
import 'package:darsak_app/feat/auth/register/data/register_content.dart';
import 'package:darsak_app/feat/auth/register/ui/register_success_dialog.dart';
import 'package:darsak_app/feat/auth/register/ui/widgets/register_identity_step.dart';
import 'package:darsak_app/feat/auth/register/ui/widgets/register_security_step.dart';
import 'package:darsak_app/feat/auth/register/ui/widgets/register_student_step.dart';
import 'package:darsak_app/feat/auth/register/ui/widgets/register_teacher_step.dart';
import 'package:darsak_app/feat/auth/ui/widgets/auth_scaffold.dart';
import 'package:darsak_app/feat/auth/ui/widgets/auth_step_footer.dart';
import 'package:darsak_app/feat/auth/ui/widgets/auth_step_header.dart';
import 'package:darsak_app/feat/auth/ui/widgets/auth_step_progress.dart';
import 'package:darsak_app/feat/auth/ui/widgets/auth_step_switcher.dart';
import '../../../../core/const/student_grade.dart';
import '../../../../core/const/user_role.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.role});

  final UserRole role;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const int _stepCount = 3;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _parentPhone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
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
    _submit();
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

  void _submit() {
    RegisterSuccessDialog.show(context, widget.role);
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
      _ => RegisterSecurityStep(
        passwordController: _password,
        confirmController: _confirm,
        termsAccepted: _terms,
        onTermsChanged: (value) => _terms = value,
        onSubmit: _next,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final content = RegisterContent.of(widget.role);

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
              label: _step == _stepCount - 1 ? 'إنشاء الحساب' : 'التالي',
              onPressed: _next,
              prompt: 'لديك حساب بالفعل؟',
              linkLabel: 'تسجيل الدخول',
              onLink: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
      ),
    );
  }
}
