import '../../../../core/cubit/base_cubit.dart';
import '../../../../core/network/error/api_error.dart';
import '../../data/repo/auth_repository.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends BaseCubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._repository) : super(const ForgotPasswordState());

  final AuthRepository _repository;

  Future<void> sendCode(String email) async {
    if (state.isBusy) return;
    safeEmit(const ForgotPasswordState(status: ForgotPasswordStatus.sending));
    final result = await _repository.sendRecoveryCode(email);
    result.when(
      success: (_) => safeEmit(
        const ForgotPasswordState(status: ForgotPasswordStatus.codeSent),
      ),
      failure: _fail,
    );
  }

  Future<void> resend(String email) async {
    if (state.isBusy) return;
    safeEmit(const ForgotPasswordState(status: ForgotPasswordStatus.resending));
    final result = await _repository.sendRecoveryCode(email);
    result.when(
      success: (_) => safeEmit(
        const ForgotPasswordState(status: ForgotPasswordStatus.resent),
      ),
      failure: _fail,
    );
  }

  Future<void> verify({required String email, required String code}) async {
    if (state.isBusy) return;
    safeEmit(const ForgotPasswordState(status: ForgotPasswordStatus.verifying));
    final result = await _repository.verifyRecoveryCode(
      email: email,
      code: code,
    );
    result.when(
      success: (_) => safeEmit(
        const ForgotPasswordState(status: ForgotPasswordStatus.codeVerified),
      ),
      failure: _fail,
    );
  }

  Future<void> resetPassword(String password) async {
    if (state.isBusy) return;
    safeEmit(const ForgotPasswordState(status: ForgotPasswordStatus.resetting));
    final result = await _repository.resetPassword(password);
    result.when(
      success: (_) => safeEmit(
        const ForgotPasswordState(status: ForgotPasswordStatus.done),
      ),
      failure: _fail,
    );
  }

  void _fail(ApiError error) {
    safeEmit(
      ForgotPasswordState(status: ForgotPasswordStatus.failure, error: error),
    );
  }
}
