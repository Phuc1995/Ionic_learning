import 'dart:io';

import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';

abstract class UploadImageApiRepository {
  Future<Either<Failure, GatewayResponse>> getAvatarPresignedUrl(String ext);
  Future<Either<Failure, GatewayResponse>> updateAvatar(objectKey);
  Future<Either<Failure, GatewayResponse>> getImagePresignedUrl(String ext, String type);
  Future<Either<Failure, bool>> uploadImage(String presignedUrl, File file, formData);
  Future<Either<Failure, GatewayResponse>> getThumbnailPresignedUrl(String ext);
}
