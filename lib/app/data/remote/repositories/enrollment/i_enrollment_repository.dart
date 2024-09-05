import 'package:dio/dio.dart';
import 'package:openimis_app/app/modules/enrollment/controller/HospitalDto.dart';
import 'package:openimis_app/app/modules/enrollment/controller/LocationDto.dart';
import 'package:openimis_app/app/modules/enrollment/controller/MembershipDto.dart';
import 'package:openimis_app/app/utils/api_response.dart';

import '../../base/idto.dart';
import '../../base/status.dart';

abstract class IEnrollmentRepository<T> {
  Future<ApiResponse> create({required IDto dto});

  Future<Status<List<LocationDto>>> getLocations();

  Future<Status<List<HealthServiceProvider>>> getHospitals();

  Future<bool?> delete({required String uuid});

  Future<Status<T>> get({required String uuid});

  Future<Status<MemberShipCard>> getMembershipCard({required String uuid});

  Future<Status<List<T>>?> getAll({
    int? limit,
    int? offset,
    bool? isFeatured,
    String? position,
    String? companyId,
  });

  Future<bool?> update({required String uuid, required IDto dto});
}
