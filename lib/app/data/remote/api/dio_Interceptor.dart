import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../modules/auth/controllers/auth_controller.dart';
import '../../../widgets/dialogs.dart';

class DioInterceptor extends Interceptor {
  final logger = Logger(printer: PrettyPrinter());
  final loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = AuthController.to.currentUser?.token;


    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = "Bearer $token";
    }

    logger.d("On new Request");
    logger.d("On new \n ${options.uri.path}");
    logger.i("Headers: \n${options.headers.toString()}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d("On new Response.");
    loggerNoStack.i("Status Code: ${response.statusCode}");
    loggerNoStack.i("Status Msg: ${response.statusMessage}");
    loggerNoStack.i("Headers: \n${response.headers.toString()}");
    loggerNoStack.v(response.data.toString());
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    logger.d("On Error.");
    loggerNoStack.e("Error Msg: ${err.message}");
    loggerNoStack.e("Error Type: ${err.type}");
    loggerNoStack.e("Error Response: ${err.response.toString()}");
    if(err.response!.statusCode==401) {
      Dialogs.errorDialog(title: "Session Expired", description: "Please log in again", btnOkOnPress: ()=> {
      AuthController.to.logout()
      });
    }
    if(err.response!.statusCode==500) {
      Dialogs.errorDialog(title: "Oops!!", description: "Please input all the data and try again", btnOkOnPress: () {

      });
    }
    super.onError(err, handler);
  }
}
