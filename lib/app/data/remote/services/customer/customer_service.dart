import 'dart:convert';

import 'package:dio/src/response.dart';
import 'package:openimis_app/app/modules/auth/controllers/auth_controller.dart';

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
  Future<Response> getAllClaims(
      {int? limit, int? offset, required String customerUuid}) async {
    try {
      return await dioClient.get(
        ApiRoutes.CLAIMS,
        queryParameters: {
          'insuree_id': customerUuid,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> getServItems(
      {int? limit, int? offset, required String customerUuid}) async {
    try {
      return await dioClient.get(
        ApiRoutes.CLAIMSERVITEMS,
        queryParameters: {
          'insuree_id': customerUuid,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> getProfile() async {
    try {
      return await dioClient.get(
        ApiRoutes.PROFILE,
        queryParameters: {
          'identifier': AuthController.to.insureeInfo()!.chfid,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> fetchClaims(
      {int? limit, int? offset, required String customerUuid}) async {
    try {
      return await dioClient.get(
        ApiRoutes.CLAIMS,
        queryParameters: {
          'insuree_id': AuthController.to.insureeInfo()!.chfid,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> fetchServItems(
      {int? limit, int? offset, required int claimID}) async {
    try {
      return await dioClient.get(
        ApiRoutes.CLAIMSERVITEMS,
        queryParameters: {
          'claim_id': claimID,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> getNationalId(String nationalId) async {
    try {
      return await dioClient.get(
        ApiRoutes.NATIONAL_ID,
        queryParameters: {
          'nationalid': nationalId,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> deviceToken(String fcmToken) async {
    try {
      return await dioClient.post(ApiRoutes.DEVICE_TOKEN,
          data: jsonEncode({
            "fcm_token": fcmToken,
            'user_id': AuthController.to.currentUser?.insureeInfo?.uuid
          }));
    } catch (e) {
      rethrow;
    }
  }
}
