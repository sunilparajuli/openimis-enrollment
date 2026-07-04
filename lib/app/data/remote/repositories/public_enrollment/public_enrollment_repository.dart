import 'package:dio/dio.dart';
import 'package:openimis_app/app/data/remote/dto/customer/national_id.dto.dart';
import 'package:openimis_app/app/utils/api_response.dart';

import 'package:openimis_app/app/modules/public_enrollment/controller/HospitalDto.dart'; // Correct import path
import '../../../../modules/enrollment/controller/LocationDto.dart';
import '../../../../modules/enrollment/controller/MembershipDto.dart';
import '../../base/idto.dart';
import '../../base/status.dart';

import '../../dto/enrollment/enrollment_in_dto.dart';
import '../../exceptions/dio_exceptions.dart';
import '../../services/enrollment_public/i_public_enrollment_service.dart';
import 'i_public_enrollment_repository.dart';

class PublicEnrollmentRepository implements IPublicEnrollmentRepository<EnrollmentInDto> {
  final IPublicEnrollmentService service;

  PublicEnrollmentRepository({required this.service});

  @override
  Future<ApiResponse<bool>> create({required IDto dto}) async {
    try {
      final response = await service.enrollment(dto: dto);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(true, message: "Enrollment successful.");
      }
      return ApiResponse.failure(response.data['message']);
    } on DioError catch (e) {
      if (e.response != null && e.response!.data != null) {
        return ApiResponse.failure(e.response!.data['message']);
      }
      return ApiResponse.failure(e.message);
    }
  }


  @override
  Future<bool?> delete({required String uuid}) async {
    return null;
  

  }

  @override
  Future<Status<EnrollmentInDto>> get({required String uuid}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Status<List<EnrollmentInDto>>?> getAll({int? limit, int? offset, bool? isFeatured, String? position, String? companyId}) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<bool?> update({required String uuid, required IDto dto}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override

  Future<Status<List<LocationDto>>> getLocations() async {
    try {

      final response = await service.locations();

      // Ensure the data is properly typed as List<dynamic>
      final data = response.data['data'] as List<dynamic>;

      // Convert the List<dynamic> to List<LocationDto>
      final locations = data.map((e) => LocationDto.fromJson(e)).toList();

      if (response.statusCode == 200) {
        return Status.success(data: locations);
      }

      return const Status.failure(reason: "Something went wrong!");
    } on DioError catch (e) {
      final errMsg = DioExceptions.fromDioError(e).toString();
      return Status.failure(reason: errMsg);
    }
  }





  @override
  Future<Status<MemberShipCard>> getMembershipCard({required String uuid}) async{
    // TODO: implement getMembershipCard
    try {
      final response = await service.membership_card(uuid: 'feb656f8-b9ea-4c88-bdb8-00d2a1aa2fa2');
      //feb656f8-b9ea-4c88-bdb8-00d2a1aa2fa2
      // Check if the response status code is 200
      if (response.statusCode == 200) {
        // Extract the data list from the 'data' key
        final resp = response.data as Map<String, dynamic>;

        final card = MemberShipCard.fromJson(resp);

        return Status.success(data: card);
      } else {
        return const Status.failure(reason: "Something went wrong!");
      }
    } on DioError catch (e) {
      final errMsg = DioExceptions.fromDioError(e).toString();
      return Status.failure(reason: errMsg);
    }
  }

  @override
  Future<ApiResponse> enrollmentSubmit(data)  async{

    try {
      final response = await service.enrollmentR(data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(true, message: "Enrollment successful.");
      }
      return ApiResponse.failure(response.data['message']);
    } on DioError catch (e) {
      if (e.response != null && e.response!.data != null) {
        return ApiResponse.failure(e.response!.data['message']);
      }
      return ApiResponse.failure(e.message);
    }
  }


  @override
  Future<Status<List<PublicHealthServiceProvider>>> getHospitals() async{
    try {
      final response = await service.hospitals();

      // Check if the response status code is 200
      if (response.statusCode == 200) {
        // Extract the data list from the 'data' key
        final resp = response.data as Map<String, dynamic>;

        final hospitals = PublicHospital.fromJson(resp);

        return Status.success(data: hospitals.data);
      } else {
        return const Status.failure(reason: "Something went wrong!");
      }
    } on DioError catch (e) {
      final errMsg = DioExceptions.fromDioError(e).toString();
      return Status.failure(reason: errMsg);
    }
  }


  @override
  Future<Status<NationalID>> getNationalId(String nationalId) async{
    try {
      final response = await service.nationalId(nationalid: nationalId);
      if (response.statusCode == 200) {
        // Extract the data list from the 'data' key
        final resp = response.data as Map<String, dynamic>;

        final personInfo = NationalID.fromJson(resp['data']);

        return Status.success(data: personInfo);
      } else {
        return const Status.failure(reason: "Something went wrong!");
      }
    } on DioError catch (e) {
      final errMsg = DioExceptions.fromDioError(e).toString();
      return Status.failure(reason: errMsg);
    }
  }



  @override
  Future<Status<String>> getPaypalAccessToken() async {
    try {
      final response = await service.getPaypalAccessToken();
      if (response.statusCode == 200) {
        return Status.success(data: response.data["access_token"]);
      }
      return const Status.failure(reason: "Unknown error");
    } on DioError catch (e) {
      return Status.failure(reason: DioExceptions.fromDioError(e).toString());
    }
  }

  @override
  Future<Status<Map<String, String>>> createPaypalPayment(Map<String, dynamic> transactions, String accessToken) async {
    try {
      final response = await service.createPaypalPayment(transactions);
      if (response.statusCode == 200) {
        final body = response.data;
        if (body.containsKey("approval_url") && body.containsKey("execute_url")) {
          return Status.success(data: {
            "executeUrl": body["execute_url"],
            "approvalUrl": body["approval_url"]
          });
        }
        return const Status.failure(reason: "Invalid response format");
      }
      return Status.failure(reason: response.data["message"] ?? "Unknown error");
    } on DioError catch (e) {
      return Status.failure(reason: DioExceptions.fromDioError(e).toString());
    }
  }

  @override
  Future<Status<Map<String, dynamic>>> executePaypalPayment(String url, String payerId, String accessToken) async {
    try {
      final response = await service.executePaypalPayment(url, payerId, accessToken);
      if (response.statusCode == 200) {
        return Status.success(data: response.data as Map<String, dynamic>);
      }
      return const Status.failure(reason: "Unknown error");
    } on DioError catch (e) {
      return Status.failure(reason: DioExceptions.fromDioError(e).toString());
    }
  }
}
