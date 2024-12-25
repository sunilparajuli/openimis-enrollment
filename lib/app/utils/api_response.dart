class ApiResponse<T> {
  T? data;
  bool error;
  String message;


  ApiResponse({required this.error, required this.message, this.data});

  factory ApiResponse.success(T data, {String message = "Success"}) {
    return ApiResponse<T>(error: false, message: message, data: data);
  }

  factory ApiResponse.failure(String message) {
    return ApiResponse<T>(error: true, message: message);
  }
}

class AsyncResult<T> {
  T? data;
  bool error;
  String message;

  AsyncResult({required this.error, required this.message, this.data});

  // Factory method for success
  factory AsyncResult.success(T data, {String message = "Success"}) {
    return AsyncResult<T>(error: false, message: message, data: data);
  }

  // Factory method for failure
  factory AsyncResult.failure(String message) {
    return AsyncResult<T>(error: true, message: message);
  }
}

// A function that returns Future<AsyncResult<T>>
Future<AsyncResult<T>> handleAsync<T>(Future<T> futureOperation) async {
  try {
    T data = await futureOperation;
    return AsyncResult.success(data);
  } catch (e) {
    return AsyncResult.failure(e.toString());
  }
}
