import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../data/remote/api/api_routes.dart';
import '../../../../data/remote/api/dio_client.dart';



class PaypalServices {
  // Set the base URL for PayPal API
  final DioClient  _dioClient;

  PaypalServices([DioClient? dioClient])
      : _dioClient = dioClient ?? DioClient(Dio());

  /// Obtain the access token from PayPal
  Future<String?> getAccessToken() async {
    try {
      final response = await _dioClient?.post(
        ApiRoutes.ACCESS_TOKEN
      );
      if (response?.statusCode == 200) {
        return response?.data["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Generate the PayPal payment request
  Future<Map<String, String>?> createPaypalPayment(
      Map<String, dynamic> transactions, String accessToken) async {
    try {
      final response = await _dioClient?.post(
        ApiRoutes.CREATE_PAYMENT,
        data: transactions,
      );

      if (response?.statusCode == 200) {
        final body = response?.data;

        // Check if the keys exist in the response body
        if (body.containsKey("approval_url") && body.containsKey("execute_url")) {
          String approvalUrl = body["approval_url"];
          String executeUrl = body["execute_url"];

          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }

        // If keys are not present or empty, return null
        return null;
      } else {
        throw Exception(response?.data["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Carry out the payment process
  Future<String?> executePayment1(String url, String payerId, String accessToken) async {
    try {
      final response = await _dioClient?.post(
        url,
        data: {"payer_id": payerId},
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response?.statusCode == 200) {
        return response?.data["id"];


      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
  Future<Map<String, dynamic>?> executePayment(String url, String payerId, String accessToken) async {
    try {
      final response = await _dioClient?.post(
        url,
        data: {"payer_id": payerId},
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response?.statusCode == 200) {
        return response?.data as Map<String, dynamic>; // Return the full response
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

}
