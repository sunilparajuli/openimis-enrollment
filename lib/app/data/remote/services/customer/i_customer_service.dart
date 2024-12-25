import 'package:dio/src/response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

abstract class ICustomerService {
  Future<Response> toggleSave({
    required String insureeUuid,
    required String claimUuid,
  });

  Future<Response> fetchClaims({
    int? limit,
    int? offset,
    required String customerUuid,
  });

  Future<Response> fetchServItems({
    int? limit,
    int? offset,
    required int claimID,
  });

  Future<Response> getProfile();
  Future<Response> getNationalId(String NationalId);
  Future<Response> deviceToken(String fcmToken);

}
