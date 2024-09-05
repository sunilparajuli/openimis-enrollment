import 'package:dio/src/response.dart';

abstract class IAuthService<T> {
  Future<Response> registerCustomer({required T dto});

  Future<Response> login({required T dto});

}
