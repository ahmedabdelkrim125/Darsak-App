import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../api_constants.dart';
import '../models/auth_response.dart';
import '../models/auth_user_model.dart';
part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST('/signup')
  @Extra({ApiConstants.skipAuthKey: true})
  Future<AuthResponse> signUp(@Body() Map<String, dynamic> body);

  @POST('/token?grant_type=password')
  @Extra({ApiConstants.skipAuthKey: true})
  Future<AuthResponse> signInWithPassword(@Body() Map<String, dynamic> body);

  @POST('/token?grant_type=refresh_token')
  @Extra({ApiConstants.skipAuthKey: true})
  Future<AuthResponse> refreshToken(@Body() Map<String, dynamic> body);

  @POST('/verify')
  @Extra({ApiConstants.skipAuthKey: true})
  Future<AuthResponse> verifyOtp(@Body() Map<String, dynamic> body);

  @POST('/resend')
  @Extra({ApiConstants.skipAuthKey: true})
  Future<void> resend(@Body() Map<String, dynamic> body);

  @POST('/recover')
  @Extra({ApiConstants.skipAuthKey: true})
  Future<void> recover(@Body() Map<String, dynamic> body);

  @GET('/user')
  Future<AuthUserModel> getUser();

  @PUT('/user')
  Future<AuthUserModel> updateUser(@Body() Map<String, dynamic> body);

  @POST('/logout?scope=local')
  Future<void> signOut();
}
