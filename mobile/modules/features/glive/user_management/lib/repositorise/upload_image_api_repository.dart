import 'dart:io';
import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';

class UploadImageApiRepository {
  final String endpoint = '/profile';

  // dio instance
  final DioClient _dioClient;

  UploadImageApiRepository(this._dioClient);

  @override
  Future<Either<Failure, GatewayResponse>> getAvatarPresignedUrl(
      String ext) async {
    try {
      final data = await _dioClient.get('$endpoint/avatar-presigned',
          queryParameters: {'fileExt': ext});
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> updateAvatar(objectKey) async {
    try {
      final data =
          await _dioClient.put('$endpoint', data: {'imageUrl': objectKey});
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> getImagePresignedUrl(
      String ext, String type) async {
    try {
      final data = await _dioClient.get('/identity/image-presigned',
          queryParameters: {'fileExt': ext.substring(1), 'type': type});
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, bool>> uploadImage(
      presignedUrl, File file, formData) async {
    try {
      String fileName = file.path.split('/').last;
      var fileSent =
          await MultipartFile.fromFile(file.path, filename: fileName);
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

  @override
  Future<Either<Failure, GatewayResponse>> getThumbnailPresignedUrl(
      String ext) async {
    try {
      final data = await _dioClient.get('/live-session/thumbnail-presigned',
          queryParameters: {'fileExt': ext});
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }
}
