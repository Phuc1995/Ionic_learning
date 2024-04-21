import 'package:common_module/utils/preference/shared_preference_helper.dart';
import 'package:common_module/utils/connectivity/network_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/message_code.dart';

class DioClient {
  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 15000;

  // dio instance
  final Dio _dio = new Dio();

  // injecting dio instance
  DioClient() {
    SharedPreferences _sharePre = Modular.get<SharedPreferences>();
    SharedPreferenceHelper sharedPrefHelper = SharedPreferenceHelper(_sharePre);
    _dio
      ..options.baseUrl = sharedPrefHelper.gatewayServer
      ..options.connectTimeout = connectionTimeout
      ..options.receiveTimeout = receiveTimeout
      ..options.headers = {'Content-Type': 'application/json; charset=utf-8'}
      ..interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options,
              RequestInterceptorHandler handler) async {
            SharedPreferenceHelper sharedPrefHelper = await SharedPreferenceHelper.getInstance();
            options.baseUrl = sharedPrefHelper.gatewayServer;
            if (options.path.contains('://localhost')) {
              int start = sharedPrefHelper.storageServer.indexOf('://');
              int end = sharedPrefHelper.storageServer.lastIndexOf(':');
              String host = start < end ? sharedPrefHelper.storageServer.substring(start, end) : sharedPrefHelper.storageServer.substring(start);
              options.path = options.path.replaceAll('://localhost', host);
            }
            // getting token
            var token = sharedPrefHelper.accessToken;

            if (token != null) {
              options.headers.putIfAbsent('Authorization', () => 'Bearer ' + token);
            } else {
              print('Auth token is null');
            }

            return handler.next(options);
          },
          onError: (DioError error, ErrorInterceptorHandler handler) async {
            if (error.response != null && error.response!.data != null) {
              String? msgCode = error.response!.data is String ? error.response!.data : error.response!.data!['messageCode'];
              // If us
              if (msgCode == MessageCode.USER_LOCKED) {
                SharedPreferenceHelper sharedPrefHelper = await SharedPreferenceHelper.getInstance();
                sharedPrefHelper.removeAccessToken();
                sharedPrefHelper.removeRefreshToken();
                sharedPrefHelper.setIsLoggedIn(false);
                Modular.to.navigate('/login');
              }
            }
            return handler.next(error);
          }
        ),
      );
  }
  // Get:-----------------------------------------------------------------------
  Future<dynamic> get(
      String uri, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    bool ok = await NetworkUtil.checkConnectivity();
    if (!ok) {
      throw DioError(requestOptions: RequestOptions(
        path: uri,
        method: 'GET',
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ));
    }
    try {
      final Response response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      if (await handleError(e)) {
        return await get(uri, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onReceiveProgress: onReceiveProgress);
      } else {
        throw e;
      }
    }
  }

  // Post:----------------------------------------------------------------------
  Future<dynamic> post(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    bool ok = await NetworkUtil.checkConnectivity();
    if (!ok) {
      throw DioError(requestOptions: RequestOptions(
        path: uri,
        method: 'POST',
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ));
    }
    try {
      final Response response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      if (await handleError(e)) {
        return await post(uri, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onSendProgress: onSendProgress, onReceiveProgress: onReceiveProgress);
      } else {
        throw e;
      }
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<dynamic> put(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    bool ok = await NetworkUtil.checkConnectivity();
    if (!ok) {
      throw DioError(requestOptions: RequestOptions(
        path: uri,
        method: 'PUT',
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ));
    }
    try {
      final Response response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      if (await handleError(e)) {
        return await put(uri, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onSendProgress: onSendProgress, onReceiveProgress: onReceiveProgress);
      } else {
        throw e;
      }
    }
  }

  // patch:-----------------------------------------------------------------------
  Future<dynamic> patch(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    bool ok = await NetworkUtil.checkConnectivity();
    if (!ok) {
      throw DioError(requestOptions: RequestOptions(
        path: uri,
        method: 'PATCH',
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ));
    }
    try {
      final Response response = await _dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      if (await handleError(e)) {
        return await patch(uri, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onSendProgress: onSendProgress, onReceiveProgress: onReceiveProgress);
      } else {
        throw e;
      }
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken
      }) async {
    bool ok = await NetworkUtil.checkConnectivity();
    if (!ok) {
      throw DioError(requestOptions: RequestOptions(
        path: uri,
        method: 'DELETE',
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ));
    }
    try {
      final Response response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      if (await handleError(e)) {
        return await delete(uri, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      } else {
        throw e;
      }
    }
  }

  // Head:--------------------------------------------------------------------
  Future<dynamic> head(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken
      }) async {
    bool ok = await NetworkUtil.checkConnectivity();
    if (!ok) {
      throw DioError(requestOptions: RequestOptions(
        path: uri,
        method: 'HEAD',
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ));
    }
    try {
      final Response response = await _dio.head(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      if (await handleError(e)) {
        return await head(uri, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      } else {
        throw e;
      }
    }
  }

  Future<bool> handleError(error) async {
      if (error is DioError && error.response != null) {
        if (error.response!.statusCode != null && error.response!.statusCode == 401) {
          print('============= Refresh Token =============');
          SharedPreferenceHelper sharedPrefHelper = await SharedPreferenceHelper.getInstance();
          try {
            final refreshToken = sharedPrefHelper.refreshToken;
            final map = await this.post('/auth/refresh-token', data: {'refreshToken': refreshToken});
            final newRefreshToken = map['data']['refreshToken'];
            final newAccessToken = map['data']['accessToken'];
            await Future.wait([
              sharedPrefHelper.setAccessToken(newAccessToken),
              sharedPrefHelper.setRefreshToken(newRefreshToken),
            ]);
            return true;
          } catch (err) {
            await Future.wait([
              sharedPrefHelper.removeAccessToken(),
              sharedPrefHelper.removeRefreshToken(),
              sharedPrefHelper.setIsLoggedIn(false),
            ]);
            Modular.to.navigate('/login');
            return false;
          }
        }
      }
      return false;
  }
}
