import 'dart:typed_data';
import 'dart:io';
import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:user_management/dto/account_param_dto.dart';
import 'package:user_management/dto/dto.dart';

class UserInfoApiRepository {
  final String endpoint = '/profile';
  final DioClient _dioClient;

  UserInfoApiRepository(this._dioClient);

  @override
  Future<Either<Failure, GatewayResponse>> updateAccountInfo(AccountDto? accountInfo) async {
    try {
      final data = await _dioClient.put('$endpoint', data: accountInfo);
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> getAvatarPresignedUrl(
      String filePath, String type) async {
    try {
      final String ext = path.extension(filePath);
      final data = await _dioClient.get('/identity/image-presigned',
          queryParameters: {'fileExt': ext.substring(1), 'type': type});
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, bool>> uploadImage(
      String presignedUrl, File file, formData) async {
    try {
      String fileName = file.path.split('/').last;
      Uint8List image = File(file.path).readAsBytesSync();
      var fileSent = MultipartFile.fromBytes(image).finalize();
      formData['file'] = fileSent;
      var postForm = FormData.fromMap(formData);
      final header = {
        Headers.contentTypeHeader: lookupMimeType(fileName),
        // set content-length
        'Authorization': "null",
      };
      await _dioClient.post(presignedUrl,
          data: postForm, options: Options(headers: header));
      return Right(true);
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  // Fetch My Profile:---------------------------------------------------------------------
  @override
  Future<Either<Failure, GatewayResponse>> fetchProfile() async {
    try {
      final data = await _dioClient.get('$endpoint');
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> getAccessStatus() async {
    try {
      final data = await _dioClient.get('$endpoint/access-status');
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> updateViewerInfo(InfoParamsDto params) async {
    try {
      final data = await _dioClient.put('$endpoint', data: {params.field: params.content});
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> updateDeviceInfo(DeviceInfoParamDto params) async {
    try {
      final data = await _dioClient.post('/device', data: params.toJson());
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> removeDeviceInfo(RemoveInfoParamsDto params) async {
    try {
      final data = await _dioClient.delete('/device/${params.deviceId}');
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

}
