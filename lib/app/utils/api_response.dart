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
