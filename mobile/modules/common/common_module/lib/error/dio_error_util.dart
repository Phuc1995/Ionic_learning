import 'dart:io';
import 'package:common_module/error/failure.dart';
import 'package:dio/dio.dart';

class DioErrorUtil {
  // general methods:------------------------------------------------------------
  static Failure handleError(dynamic error) {
    String message = "";
    String messageCode = 'UNKNOWN_ERROR';
    if (error is DioError) {
      if(error.error is SocketException){
        return NetworkFailure();
      }
      message = error.message;
      switch (error.type) {
        case DioErrorType.cancel:
          messageCode = 'DIO_ERROR_CANCEL';
          message = "Request to API server was cancelled";
          break;
        case DioErrorType.connectTimeout:
          messageCode = 'DIO_ERROR_CONNECTION_TIMEOUT';
          message = "Connection timeout with API server";
          break;
        case DioErrorType.other:
          messageCode = 'DIO_ERROR_OTHER';
          message = "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.receiveTimeout:
          messageCode = 'DIO_ERROR_RECEIVE_TIMEOUT';
          message = "Receive timeout in connection with API server";
          break;
        case DioErrorType.response:
          if (error.response!.data is String) {
            message = error.response!.data??messageCode;
          } else {
            messageCode = error.response!.data!['messageCode']??'UNKNOWN_ERROR';
            if(error.response!.data!['message'] is List){
              message = error.response!.data!['message'][0];
            } else {
              message = error.response!.data!['message']??messageCode;
            }
          }
          break;
        case DioErrorType.sendTimeout:
          messageCode = 'DIO_ERROR_SEND_TIMEOUT';
          message = "Send timeout in connection with API server";
          break;
      }
      return DioFailure(message: message, messageCode: messageCode, statusCode: error.response != null ? error.response!.statusCode : null);
    } else {
      message = "Unexpected error occurred";
      return LocalFailure();
    }
  }
}