import 'package:dio/src/response.dart';

import '../../../local/config/app_config.dart';
import '../../api/api_routes.dart';
import '../../api/dio_client.dart';
import 'i_root_service.dart';
import '../../base/idto.dart';

class RootService implements IRootService<IDto> {
  final DioClient dioClient;

  RootService({required this.dioClient});

  @override
  Future<Response> getConfig() async{
    try {
      return await dioClient.get(ApiRoutes.APP_CONFIG);
    } catch (e) {
      rethrow;
    }
  }




}
