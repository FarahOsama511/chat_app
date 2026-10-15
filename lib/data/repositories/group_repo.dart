import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/networking/api_constants.dart';
import '../../core/networking/api_service.dart';
import '../models/group_model.dart';

import '../models/rooms_response_model.dart';

abstract class GroupRepo {
  Future<Either<String, CreateGroupResponseModel>> createGroup(
    CreateGroupRequestModel request,
  );
  Future<Either<String, List<GroupModel>>> getRooms({String? type});
}

class GroupRepoImpl implements GroupRepo {
  final DioHelper _dioHelper;

  GroupRepoImpl(this._dioHelper);

  @override
  Future<Either<String, CreateGroupResponseModel>> createGroup(
    CreateGroupRequestModel request,
  ) async {
    try {
      final formData = await request.toFormData();
      final response = await _dioHelper.postData(
        url: ApiEndpoints.createGroup,
        data: formData,
      );
      log('Create Group Response: ${response.data}');

      final responseModel = CreateGroupResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (responseModel.status == false) {
        return Left(responseModel.message ?? 'Failed to create group');
      }

      return Right(responseModel);
    } catch (e) {
      log('Create Group Error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<GroupModel>>> getRooms({String? type}) async {
    try {
      final response = await _dioHelper.getData(
        url: ApiEndpoints.getRooms,
        query: (type != null && type.isNotEmpty) ? {"type": type} : null,
      );
      log('Get Rooms Response: ${response.data}');

      final roomsResponse = RoomsResponseModel.fromJson(response.data);

      return Right(roomsResponse.rooms ?? []);
    } catch (e) {
      log('Get Rooms Error: $e');
      return Left(e.toString());
    }
  }
}
