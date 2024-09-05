import 'package:openimis_app/app/data/remote/base/idto.dart';
import 'package:openimis_app/app/data/remote/base/status.dart';

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

  Future<Status<IDto>> getProfile({required String customerUuid});

  Future<Status<String>> getAvatar({required String customerUuid});
}
