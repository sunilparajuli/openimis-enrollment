import 'package:dio/src/response.dart';

abstract class IRootService<T> {
  Future<Response> getConfig();
}
