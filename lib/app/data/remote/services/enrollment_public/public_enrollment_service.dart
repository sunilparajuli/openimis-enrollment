import 'package:dio/src/response.dart';

import '../../../../modules/enrollment/controller/LocationDto.dart';
import '../../api/api_routes.dart';
import '../../api/dio_client.dart';
import 'i_public_enrollment_service.dart';
import '../../base/idto.dart';

class PublicEnrollmentService implements IPublicEnrollmentService<IDto> {
  final DioClient dioClient;

  PublicEnrollmentService({required this.dioClient});

  @override
  Future<Response> enrollment({required IDto dto}) async {
    try {
      return await dioClient.post(ApiRoutes.ENROLLMENT, data: dto.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> locations() async{
     //LocationDto dto = LocationDto();
    try {
      return await dioClient.get(ApiRoutes.LOCATIONS);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> hospitals() async {
    try {
      return await dioClient.get(ApiRoutes.HOSPITALS);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> membership_card({required String uuid}) async {
    try {
      return await dioClient.get(ApiRoutes.MEMBERSHIP_CARD+'/${uuid}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> enrollmentR(data) async {
    try {
      return await dioClient.post(ApiRoutes.ENROLLMENT, data: data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> nationalId({required String nationalid}) async{
    try {
      return await dioClient.get(ApiRoutes.NATIONAL_ID , queryParameters: {
        "national_id" : nationalid
      });
    } catch (e) {
      rethrow;
    }
  }


}
