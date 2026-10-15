import 'dart:developer';
import 'package:chatapp/core/helpers/security_sharedpref.dart';
import 'package:chatapp/core/helpers/sharedpref_helper.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/networking/api_constants.dart';
import '../../../../../core/networking/api_service.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

abstract class LoginRepo {
  Future<Either<String, LoginResponseModel>> login(LoginRequestModel request);
}

class LoginRepoImpl implements LoginRepo {
  final DioHelper _dioHelper;
  LoginRepoImpl(this._dioHelper);

  @override
  Future<Either<String, LoginResponseModel>> login(
    LoginRequestModel request,
  ) async {
    try {
      final response = await _dioHelper.postData(
        url: ApiEndpoints.loginEndpoint,
        data: request.toJson(),
      );

      final loginResponseModel = LoginResponseModel.fromJson(response.data);
      await SharedprefHelper.setLoggedIn(true);

      // حفظ التوكن بأمان في SecuritySharedpref
      if (loginResponseModel.token != null &&
          loginResponseModel.token!.isNotEmpty) {
        await SecuritySharedpref.setToken(loginResponseModel.token!);
      }
      if (loginResponseModel.user?.id != null) {
        await SharedprefHelper.setData(
          'user_id',
          loginResponseModel.user!.id.toString(),
        );
      }
      return Right(loginResponseModel);
    } catch (e) {
      log('Login Error: $e');
      return Left(e.toString());
    }
  }
}
