import 'package:dio/src/response.dart';

abstract class ICustomerService {
  Future<Response> toggleSave({
    required String insureeUuid,
    required String claimUuid,
  });

  Future<Response> getAllClaims({
    int? limit,
    int? offset,
    required String customerUuid,
  });

  Future<Response> getProfile({
    required String insureeUuid,
  });

}
