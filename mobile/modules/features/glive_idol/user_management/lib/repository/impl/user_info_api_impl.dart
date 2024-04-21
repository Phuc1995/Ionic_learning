import 'dart:typed_data';
import 'dart:io';
import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:user_management/domain/entity/request/account-info.dart';
import 'package:path/path.dart' as path;
import 'package:user_management/domain/usecase/auth/remove_device_info.dart';
import 'package:user_management/domain/usecase/auth/update_device_info.dart';
import 'package:user_management/domain/usecase/auth/update_info_idol.dart';
import 'package:user_management/repository/user_info_api_repository.dart';

class UserInfoApiImpl implements UserInfoApiRepository {
  final String endpoint = '/profile';
  // dio instance
  final DioClient _dioClient;

  UserInfoApiImpl(this._dioClient);

  //Right() must be return Entity or boolean
  @override
  Future<Either<Failure, GatewayResponse>> updateAccountInfo(
      AccountDto? accountInfo) async {
    try {
      final data = await _dioClient.post('/identity', data: accountInfo);
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
  Future<Either<Failure, GatewayResponse>> updateInfoForIdol(InfoParams params) async {
    try {
      final data = await _dioClient.put('$endpoint', data: {params.field: params.content});
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> updateDeviceInfo(DeviceInfoParams params) async {
    try {
      final data = await _dioClient.post('/device', data: params.toJson());
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> removeDeviceInfo(RemoveInfoParams params) async {
    try {
      final data = await _dioClient.delete('/device/${params.deviceId}');
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> updateSkillsIdol(String skills) async {
    try {
      final data = await _dioClient.put('$endpoint/skills', data: {"skills": skills});
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> getAllSkill() async {
    try {
      final data = await _dioClient.get('/skill',);
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> getSkillIdol() async {
    try {
      final data = await _dioClient.get('$endpoint/skills');
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

}
