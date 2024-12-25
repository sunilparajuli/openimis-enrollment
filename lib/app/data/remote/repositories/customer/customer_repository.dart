import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:openimis_app/app/data/remote/base/idto.dart';
import 'package:openimis_app/app/modules/Insuree/views/profile.dart';
import 'package:openimis_app/app/utils/api_response.dart';


import '../../base/status.dart';
import '../../dto/customer/claim_is_dto.dart';
import '../../dto/customer/claim_out_dto.dart';
import '../../dto/customer/national_id.dto.dart';
import '../../dto/customer/toggle_save_out_dto.dart';

import '../../dto/enrollment/enrollment_in_dto.dart';
import '../../exceptions/dio_exceptions.dart';
import '../../services/customer/i_customer_service.dart';
import 'i_customer_repository.dart';

class CustomerRepository implements ICustomerRepository {
  final ICustomerService service;

  CustomerRepository({required this.service});

  @override
  Future<Status<List<Claim>>> getAllCalims({
    int? limit,
    int? offset,
    required String customerUuid,
  }) async {
    try {
      final response = await service.fetchClaims(limit: limit, customerUuid: customerUuid, offset: offset);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Claim> claims = data.map((item) => Claim.fromJson(item)).toList();
        return Status.success(data: claims);
      }

      return const Status.failure(reason: "Something went wrong!");
    } on DioError catch (e) {
      final errMsg = DioExceptions.fromDioError(e).toString();
      return Status.failure(reason: errMsg);
    }
  }




  @override
  Future<Status<InsureeClaimResponse>> getServItems({int? limit, int? offset, required int claimID}) async{
    try {
      final response = await service.fetchServItems(claimID: claimID);
      final insureeClaimResponse = InsureeClaimResponse.fromJson(response.data);
      return Status.success(data: insureeClaimResponse);

    } on DioError catch (e) {
      final errMsg = DioExceptions.fromDioError(e).toString();
      return Status.failure(reason: errMsg);
    }
  }

  @override
  Future<Status<String>> getAvatar({required String customerUuid}) {
    // TODO: implement getAvatar
    throw UnimplementedError();
  }

  @override
  Future<Status<FHIRPatient>> getProfile() async{
    try {
      final response = await service.getProfile();
      final patientFhirResponse = FHIRPatient.fromJson(response.data);
      return Status.success(data: patientFhirResponse);

    } on DioError catch (e) {
      final errMsg = DioExceptions.fromDioError(e).toString();
      return Status.failure(reason: errMsg);
    }
  }


  @override
  Future<Status<IDto>> toggleSave({required String customerUuid, required String jobUuid}) {
    // TODO: implement toggleSave
    throw UnimplementedError();
  }

  @override
  Future<Status<NationalID>> getNationalId({required String nationalId}) async{
    try {
      final response = await service.getNationalId(nationalId);
      final data = NationalID.fromJson(response.data);
      return Status.success(data: data);

    } on DioError catch (e) {
      final errMsg = DioExceptions.fromDioError(e).toString();
      return Status.failure(reason: errMsg);
    }
  }

  @override
  Future<Status> postDeviceToken({required String fcmToken}) async{
    try {
      final response = await service.deviceToken(fcmToken);
      final data = response.data;
      return Status.success(data: data);

    } on DioError catch (e) {
      final errMsg = DioExceptions.fromDioError(e).toString();
      return Status.failure(reason: errMsg);
    }
  }


}