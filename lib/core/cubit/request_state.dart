import 'package:equatable/equatable.dart';
import '../network/error/api_error.dart';

enum RequestStatus { initial, loading, success, failure }

class RequestState<T> extends Equatable {
  const RequestState({
    this.status = RequestStatus.initial,
    this.data,
    this.error,
  });

  const RequestState.loading({this.data})
    : status = RequestStatus.loading,
      error = null;

  const RequestState.success(T this.data)
    : status = RequestStatus.success,
      error = null;

  const RequestState.failure(ApiError this.error, {this.data})
    : status = RequestStatus.failure;

  final RequestStatus status;
  final T? data;
  final ApiError? error;

  bool get isInitial => status == RequestStatus.initial;
  bool get isLoading => status == RequestStatus.loading;
  bool get isSuccess => status == RequestStatus.success;
  bool get isFailure => status == RequestStatus.failure;

  @override
  List<Object?> get props => [status, data, error];
}
