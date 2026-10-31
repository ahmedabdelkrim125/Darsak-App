import '../network/api_result.dart';
import 'base_cubit.dart';
import 'request_state.dart';

class RequestCubit<T> extends BaseCubit<RequestState<T>> {
  RequestCubit() : super(const RequestState());

  Future<void> run(Future<ApiResult<T>> Function() request) async {
    safeEmit(RequestState<T>.loading(data: state.data));
    final result = await request();
    result.when(
      success: (data) => safeEmit(RequestState<T>.success(data)),
      failure: (error) =>
          safeEmit(RequestState<T>.failure(error, data: state.data)),
    );
  }

  void reset() => safeEmit(const RequestState());
}
