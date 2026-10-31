import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../api_constants.dart';
import '../models/profile_model.dart';

part 'profile_api.g.dart';

@RestApi()
abstract class ProfileApi {
  factory ProfileApi(Dio dio, {String? baseUrl}) = _ProfileApi;

  @GET('/profiles')
  Future<List<ProfileModel>> getProfile(
    @Query('id') String id,
    @Query('select') String select,
  );

  @POST('/rpc/is_username_available')
  @Extra({ApiConstants.skipAuthKey: true})
  Future<bool> isUsernameAvailable(@Body() Map<String, dynamic> body);
}
