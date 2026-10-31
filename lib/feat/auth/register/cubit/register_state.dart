import 'package:equatable/equatable.dart';
import '../../../../core/network/error/api_error.dart';

enum RegisterStatus {
  idle,
  submitting,
  codeSent,
  resending,
  resent,
  verifying,
  verified,
  failure,
}

class RegisterState extends Equatable {
  const RegisterState({this.status = RegisterStatus.idle, this.error});

  final RegisterStatus status;
  final ApiError? error;

  bool get isBusy =>
      status == RegisterStatus.submitting ||
      status == RegisterStatus.resending ||
      status == RegisterStatus.verifying;

  @override
  List<Object?> get props => [status, error];
}
