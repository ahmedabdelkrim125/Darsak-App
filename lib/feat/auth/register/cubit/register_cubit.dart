import '../../../../core/const/student_grade.dart';
import '../../../../core/const/user_role.dart';
import '../../../../core/cubit/base_cubit.dart';
import '../../../../core/network/error/api_error.dart';
import '../../data/repo/auth_repository.dart';
import 'register_state.dart';

class RegisterCubit extends BaseCubit<RegisterState> {
  RegisterCubit(this._repository) : super(const RegisterState());

  final AuthRepository _repository;

  Future<void> submit({
    required UserRole role,
    required String fullName,
    required String username,
    required String email,
    required String password,
    String? subject,
    String? phone,
    String? parentPhone,
    StudentGrade? grade,
  }) async {
    if (state.isBusy) return;
    safeEmit(const RegisterState(status: RegisterStatus.submitting));
    final result = await _repository.signUp(
      role: role,
      fullName: fullName,
      username: username,
      email: email,
      password: password,
      subject: subject,
      phone: phone,
      parentPhone: parentPhone,
      grade: grade,
    );
    result.when(
      success: (codeRequired) => safeEmit(
        RegisterState(
          status: codeRequired
              ? RegisterStatus.codeSent
              : RegisterStatus.verified,
        ),
      ),
      failure: _fail,
    );
  }

  Future<void> verify({required String email, required String code}) async {
    if (state.isBusy) return;
    safeEmit(const RegisterState(status: RegisterStatus.verifying));
    final result = await _repository.verifySignupCode(email: email, code: code);
    result.when(
      success: (_) =>
          safeEmit(const RegisterState(status: RegisterStatus.verified)),
      failure: _fail,
    );
  }

  Future<void> resend(String email) async {
    if (state.isBusy) return;
    safeEmit(const RegisterState(status: RegisterStatus.resending));
    final result = await _repository.resendSignupCode(email);
    result.when(
      success: (_) =>
          safeEmit(const RegisterState(status: RegisterStatus.resent)),
      failure: _fail,
    );
  }

  void _fail(ApiError error) {
    safeEmit(RegisterState(status: RegisterStatus.failure, error: error));
  }
}
