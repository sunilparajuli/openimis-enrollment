import 'package:openimis_app/app/modules/enrollment/controller/LocationDto.dart';
import 'package:openimis_app/app/modules/enrollment/controller/MembershipDto.dart';
import 'package:openimis_app/app/utils/api_response.dart';
import 'package:openimis_app/app/data/remote/dto/customer/national_id.dto.dart';

import '../../../../modules/public_enrollment/controller/HospitalDto.dart';
import '../../base/idto.dart';
import '../../base/status.dart';

abstract class IPublicEnrollmentRepository<T> {

  Future<ApiResponse> create({required IDto dto});

  Future<Status<List<LocationDto>>> getLocations();

  Future<Status<List<PublicHealthServiceProvider>>> getHospitals();

  Future<bool?> delete({required String uuid});

  Future<Status<T>> get({required String uuid});

  Future<ApiResponse> enrollmentSubmit(dynamic data);

  Future<Status<MemberShipCard>> getMembershipCard({required String uuid});

  Future<Status<List<T>>?> getAll({
    int? limit,
    int? offset,
    bool? isFeatured,
    String? position,
    String? companyId,
  });

  Future<bool?> update({required String uuid, required IDto dto});

  Future<Status<String>> getPaypalAccessToken();
  
  Future<Status<Map<String, String>>> createPaypalPayment(Map<String, dynamic> transactions, String accessToken);
  
  Future<Status<Map<String, dynamic>>> executePaypalPayment(String url, String payerId, String accessToken);

  Future<Status<NationalID>> getNationalId(String nationalId);
}
