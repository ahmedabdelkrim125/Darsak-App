import 'package:equatable/equatable.dart';
import '../../../../core/network/error/api_error.dart';

enum ForgotPasswordStatus {
  idle,
  sending,
  codeSent,
  resending,
  resent,
  verifying,
  codeVerified,
  resetting,
  done,
  failure,
}

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.idle,
    this.error,
  });

  final ForgotPasswordStatus status;
  final ApiError? error;

  bool get isBusy =>
      status == ForgotPasswordStatus.sending ||
      status == ForgotPasswordStatus.resending ||
      status == ForgotPasswordStatus.verifying ||
      status == ForgotPasswordStatus.resetting;

  @override
  List<Object?> get props => [status, error];
}
