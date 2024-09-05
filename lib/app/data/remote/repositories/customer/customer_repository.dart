import 'package:dio/dio.dart';
import 'package:openimis_app/app/data/remote/base/idto.dart';


import '../../base/status.dart';
import '../../dto/customer/toggle_save_out_dto.dart';

import '../../dto/enrollment/enrollment_in_dto.dart';
import '../../exceptions/dio_exceptions.dart';
import '../../services/customer/i_customer_service.dart';
import 'i_customer_repository.dart';

class CustomerRepository implements ICustomerRepository {
  final ICustomerService service;

  CustomerRepository({required this.service});

  @override
  Future<Status<List<IDto>>> getAllCalims({int? limit, int? offset, required String customerUuid}) {
    // TODO: implement getAllSavedJobs
    throw UnimplementedError();
  }

  @override
  Future<Status<String>> getAvatar({required String customerUuid}) {
    // TODO: implement getAvatar
    throw UnimplementedError();
  }

  @override
  Future<Status<IDto>> getProfile({required String customerUuid}) {
    // TODO: implement getProfile
    throw UnimplementedError();
  }

  @override
  Future<Status<IDto>> toggleSave({required String customerUuid, required String jobUuid}) {
    // TODO: implement toggleSave
    throw UnimplementedError();
  }


}