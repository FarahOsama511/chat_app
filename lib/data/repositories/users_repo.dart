import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/networking/api_constants.dart';
import '../../core/networking/api_service.dart';
import '../../ui/features/auth/data/models/login_response_model.dart';
import '../models/users_response_model.dart';

abstract class UsersRepo {
  Future<Either<String, List<User>>> getUsers();
}

class UsersRepoImpl implements UsersRepo {
  final DioHelper _dioHelper;

  UsersRepoImpl(this._dioHelper);

  @override
  Future<Either<String, List<User>>> getUsers() async {
    try {
      final response = await _dioHelper.getData(
        url: ApiEndpoints.usersEndpoint,
      );
      log('Get Users Response: ${response.data}');

      final usersResponse = UsersResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      return Right(usersResponse.users ?? []);
    } catch (e) {
      log('Get Users Error: $e');
      return Left(e.toString());
    }
  }
}
