import 'dart:io';

import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/repository/upload_image_api_repository.dart';
import 'package:user_management/domain/entity/image_path/image_path.dart';
import 'package:path/path.dart' as path;
import 'package:common_module/common_module.dart';

class ImageController extends GetxController {
  UploadImageApiRepository _uploadImageApi =
      Modular.get<UploadImageApiRepository>();

  // constructor:---------------------------------------------------------------
  ImageController();

  // store variables:-----------------------------------------------------------
  var success = false.obs;
  var loading = false.obs;

  var armorial = ''.obs;

  Future<Either<ImagePath, ImagePath>> upload(BuildContext context, ImagePath imageUrl) async {
    final String ext = path.extension(imageUrl.path);
    final eitherUrl =
        await _uploadImageApi.getAvatarPresignedUrl(ext.substring(1));
    return eitherUrl.fold((_) {
      return Left(ImagePath(
          path: '',
          type: '',
          isSuccess: false,
          message: 'avatar_presigned_url_error'.tr));
    }, (dataPresignedUrl) async {
      final eitherUpload = await _uploadImageApi.uploadImage(
          dataPresignedUrl.data["presignedUrl"],
          File(imageUrl.path),
          dataPresignedUrl.data["formData"]);
      return eitherUpload.fold((err) {
        String msg = 'avatar_error_upload'.tr;
        if (err is DioFailure) {
          if (MessageCode.BAD_REQUEST == err.messageCode) {
            msg = 'avatar_error'.tr;
          }
        }
        return Left(ImagePath(
            path: '', type: '', isSuccess: false, message: msg));
      }, (res) async {
        final eitherUpdate = await _uploadImageApi
            .updateAvatar(dataPresignedUrl.data["avatarObjectKey"]);
        return eitherUpdate.fold((l) {
          return Left(ImagePath(
              path: '',
              type: '',
              isSuccess: false,
              message: 'avatar_error_unknown'.tr));
        }, (r) {
          return Right(ImagePath(
              path: dataPresignedUrl.data["avatarObjectKey"],
              type: '',
              isSuccess: true,
              message: 'Success'));
        });
      });
    });
  }

  Future<List<ImagePath>> uploadMultipleImage(
      BuildContext context, List<ImagePath> imageUrl) async {
    List<ImagePath> pathResults = [];
    try {
      loading.value = true;
      for (int i = 0; i < imageUrl.length; i++) {
        final String ext = path.extension(imageUrl[i].path);
        GatewayResponse dataPresignedUrl =
            (await _uploadImageApi.getAvatarPresignedUrl(ext.substring(1)))
                .getOrElse(() => GatewayResponse(data: {}));
        await _uploadImageApi.uploadImage(dataPresignedUrl.data["presignedUrl"],
            File(imageUrl[i].path), dataPresignedUrl.data["formData"]);
        pathResults.add(new ImagePath(
            path: dataPresignedUrl.data["avatarObjectKey"],
            type: imageUrl[i].type));
      }
      loading.value = false;
      return pathResults;
    } catch (err) {
      loading.value = false;
      // String msg = 'avatar_error_unknown'.tr;
      // if (err is DioError) {
      //   if (err.response != null && err.response.toString().contains(MessageCode.BAD_REQUEST)) {
      //     msg = 'avatar_error'.tr;
      //   }
      // }
      return pathResults;
    }
  }

  Future<bool> checkFileUpload(String imageUrl) async {
    try {
      final length = await File(imageUrl).length();
      return await length <= 20480000 &&
          ['.jpg', '.jpeg', '.png'].contains(path.extension(imageUrl));
    } catch (err) {
      return false;
    }
  }

  Future<Either<ImagePath, ImagePath>> uploadThumbnail(BuildContext context, ImagePath imageUrl) async {
    final String ext = path.extension(imageUrl.path);
    final eitherUrl =
    await _uploadImageApi.getThumbnailPresignedUrl(ext.substring(1));
    return eitherUrl.fold((_) {
      return Left(ImagePath(
          path: '',
          type: '',
          isSuccess: false,
          message: 'live_thumbnail_presigned_url_error'.tr));
    }, (dataPresignedUrl) async {
      final eitherUpload = await _uploadImageApi.uploadImage(
          dataPresignedUrl.data["presignedUrl"],
          File(imageUrl.path),
          dataPresignedUrl.data["formData"]);
      return eitherUpload.fold((err) {
        String msg = 'live_thumbnail_error_upload'.tr;
        if (err is DioFailure) {
          if (MessageCode.BAD_REQUEST == err.messageCode) {
            msg = 'live_thumbnail_error'.tr;
          }
        }
        return Left(ImagePath(
            path: '', type: '', isSuccess: false, message: msg));
      }, (res) async {
        return Right(ImagePath(
            path: dataPresignedUrl.data["liveThumbnailObjectKey"],
            type: '',
            isSuccess: true,
            message: 'Success'));
      });
    });
  }
}
