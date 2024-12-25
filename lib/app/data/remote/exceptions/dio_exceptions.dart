import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  late String message;

  static const Map<String, String> _errorCodes = {
    '400': 'Bad Request',
    '401': 'Unauthorized',
    '403': 'Forbidden',
    '404': 'Not Found',
    '408': 'Request Timeout',
    '500': 'Internal Server Error',
    '502': 'Bad Gateway',
    '503': 'Service Unavailable',
    '504': 'Gateway Timeout',
    '505': 'HTTP Version Not Supported',
    '511': 'Network Authentication Required',
    '520': 'Unknown Error',
    '521': 'Web Server Is Down',
    '522': 'Connection Timed Out',
    '523': 'Origin Is Unreachable',
    '524': 'A Timeout Occurred',
    '525': 'SSL Handshake Failed',
    '526': 'Invalid SSL Certificate',
    '530': 'Origin DNS Error',
    '598': 'Network Read Timeout Error',
    '599': 'Network Connect Timeout Error',
  };

  static const Map<String, String> _errorTypes = {
    'cancel': 'Request to API server was cancelled',
    'connectTimeout': 'Connection timeout with API server',
    'default': 'Connection to API server failed due to internet connection',
    'receiveTimeout': 'Receive timeout in connection with API server',
    'sendTimeout': 'Send timeout in connection with API server',
    'other': 'Connection to API server failed due to internet connection',
  };

  DioExceptions.fromDioError(DioError dioError) {
    message = _getErrorMessage(dioError);
  }

  String _getErrorMessage(DioError error) {
    String errorType = error.type.toString().split('.').last;
    String errorMessage;

    // Check for status code 400 (Bad Request)
    if (error.response?.statusCode == 400 && error.response?.data != null) {
      // Handle a list of errors in the response data
      errorMessage = _extractErrorMessages(error.response!.data);
    } else {
      // Attempt to extract the error message from error.response?.data or error.response?.error
      var responseData = error.response?.data;
      var errorData = responseData is Map<String, dynamic> ? responseData['error'] : null;

      // Handle other error cases
      errorMessage = _errorTypes[errorType] ??
          errorData ??
          _errorCodes[error.response?.statusCode.toString()] ??
          'Something went wrong';
    }

    return errorMessage;
  }


  String _extractErrorMessages(dynamic errorData) {
    List<String> errorMessages = [];

    if (errorData is Map<String, dynamic>) {
      errorData.forEach((key, value) {
        if (value is List) {
          for (var msg in value) {
            errorMessages.add(msg.toString());
          }
        } else if (value is String) {
          errorMessages.add(value);
        } else if (value is Map<String, dynamic>) {
          errorMessages.add(_extractErrorMessages(value)); // Recursively handle nested maps
        }
      });
    } else if (errorData is List) {
      for (var item in errorData) {
        errorMessages.add(item.toString());
      }
    } else if (errorData is String) {
      errorMessages.add(errorData);
    }

    return errorMessages.join('\n');
  }

  @override
  String toString() => message;
}
