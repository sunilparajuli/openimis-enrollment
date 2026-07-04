import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:openimis_app/app/data/remote/services/root/root_service.dart';

import '../../base/status.dart';
import '../../exceptions/dio_exceptions.dart';
import 'i_root_repository.dart';

class RootRepository implements IRootRepository<Status<dynamic>> {

  final storage = GetStorage();
  final RootService rootService;

  RootRepository({
    required this.rootService,
  });
  @override
  Future<Status> fetchConfig() async{
    try {
      final response = await rootService.getConfig();
      await storage.write('configurations', response.data);
      return Status.success(
          data: response.data//AppConfig.fromJson(response.data)
      );
    } on DioError catch (e) {
      final errMsg = DioExceptions.fromDioError(e).toString();
      return Status.failure(reason: errMsg);
    }
  }


}






