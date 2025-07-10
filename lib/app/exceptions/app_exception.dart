import 'package:dio/dio.dart';

AppExceptions handleDioException(DioException e) {
  switch (e.response?.statusCode) {
    case 400:
      return AppExceptions(
          e.response?.data["detail"] ?? "Something went wrong");
    case 401:
      return AppExceptions('Unauthorized: Please login again');
    case 422:
      return AppExceptions('Validation error: ${e.response?.data['message']}');
    case 403:
      return AppExceptions('Access denied');
    case 404:
      return AppExceptions('Event not found');
    case 500:
      return AppExceptions('Server error: Please try again later');
    default:
      return AppExceptions('Network error: ${e.message}');
  }
}

class AppExceptions implements Exception {
  final String message;
  final String? code;

  AppExceptions(this.message, {this.code});

  @override
  String toString() {
    return 'AppExceptions{message: $message, code: $code}';
  }
}

class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException(this.message, {this.code});

  @override
  String toString() {
    return 'AuthException{message: $message, code: $code}';
  }
}
