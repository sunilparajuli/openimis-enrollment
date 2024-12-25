import 'package:dio/src/response.dart';

abstract class IPublicEnrollmentService<T> {

  Future<Response> enrollment({required T dto});
  Future<Response> enrollmentR(data);
  Future<Response> locations();
  Future<Response> hospitals();
  Future<Response> membership_card({required String uuid});
  Future<Response> nationalId({required String nationalid});
}
