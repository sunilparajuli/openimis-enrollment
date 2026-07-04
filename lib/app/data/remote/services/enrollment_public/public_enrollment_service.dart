import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';

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
      return await dioClient.get('${ApiRoutes.MEMBERSHIP_CARD}/$uuid');
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

  @override
  Future<Response> getPaypalAccessToken() async {
    try {
      return await dioClient.post(ApiRoutes.ACCESS_TOKEN);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> createPaypalPayment(Map<String, dynamic> transactions) async {
    try {
      return await dioClient.post(ApiRoutes.CREATE_PAYMENT, data: transactions);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> executePaypalPayment(String url, String payerId, String accessToken) async {
    try {
      return await dioClient.post(
        url,
        data: {"payer_id": payerId},
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
