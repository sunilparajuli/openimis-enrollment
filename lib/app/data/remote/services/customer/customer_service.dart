import 'package:dio/src/response.dart';

import '../../api/api_routes.dart';
import '../../api/dio_client.dart';
import 'i_customer_service.dart';

class CustomerService implements ICustomerService {
  final DioClient dioClient;

  CustomerService({required this.dioClient});

 

  @override
  Future<Response> toggleSave({
    required String insureeUuid,
    required String claimUuid,
  }) async {
    try {
      return await dioClient.post(
        ApiRoutes.TOGGLE_SAVE,
        queryParameters: {
          'customer_id': insureeUuid,
          'job_id': claimUuid,
        },
      );
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<Response> getAllClaims({int? limit, int? offset, required String customerUuid}) {
    // TODO: implement getAllClaims
    throw UnimplementedError();
  }

  @override
  Future<Response> getProfile({required String insureeUuid}) {
    // TODO: implement getProfile
    throw UnimplementedError();
  }
}
