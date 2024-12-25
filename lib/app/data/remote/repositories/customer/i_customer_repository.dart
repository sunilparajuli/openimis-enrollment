import 'package:openimis_app/app/data/remote/base/idto.dart';
import 'package:openimis_app/app/data/remote/base/status.dart';
import 'package:openimis_app/app/utils/api_response.dart';

abstract class ICustomerRepository {
  Future<Status<IDto>> toggleSave({
    required String customerUuid,
    required String jobUuid,
  });

  Future<Status<List<IDto>>> getAllCalims({
    int? limit,
    int? offset,
    required String customerUuid,
  });

  Future<Status<IDto>> getServItems({
    int? limit,
    int? offset,
    required int claimID,
  });

  Future<Status<IDto>> getProfile();

  Future<Status<String>> getAvatar({required String customerUuid});


  Future<Status<dynamic>> getNationalId({required String nationalId});
  Future<Status<dynamic>> postDeviceToken({required String fcmToken});
}
