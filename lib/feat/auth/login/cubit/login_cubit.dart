import '../../../../core/const/user_role.dart';
import '../../../../core/cubit/request_cubit.dart';
import '../../data/repo/auth_repository.dart';

class LoginCubit extends RequestCubit<UserRole> {
  LoginCubit(this._repository);

  final AuthRepository _repository;

  Future<void> login({
    required String email,
    required String password,
    required UserRole role,
  }) {
    if (state.isLoading) return Future<void>.value();
    return run(
      () => _repository.signIn(
        email: email,
        password: password,
        expectedRole: role,
      ),
    );
  }
}
