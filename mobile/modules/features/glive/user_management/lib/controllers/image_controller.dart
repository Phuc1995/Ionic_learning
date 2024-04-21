import 'dart:io';
import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/dto/image_path_dto.dart';
import 'package:user_management/repositorise/upload_image_api_repository.dart';
import 'package:path/path.dart' as path;

class ImageController extends GetxController {
  UploadImageApiRepository _uploadImageApi =
      Modular.get<UploadImageApiRepository>();

  // constructor:---------------------------------------------------------------
  ImageController();

  // store variables:-----------------------------------------------------------
  var success = false.obs;
  var loading = false.obs;

  var armorial = ''.obs;

  Future<Either<ImagePathDto, ImagePathDto>> upload(BuildContext context, ImagePathDto imageUrl) async {
    final String ext = path.extension(imageUrl.path);
    final eitherUrl =
        await _uploadImageApi.getAvatarPresignedUrl(ext.substring(1));
    return eitherUrl.fold((_) {
      return Left(ImagePathDto(
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
        return Left(ImagePathDto(
            path: '', type: '', isSuccess: false, message: msg));
      }, (res) async {
        final eitherUpdate = await _uploadImageApi
            .updateAvatar(dataPresignedUrl.data["avatarObjectKey"]);
        return eitherUpdate.fold((l) {
          return Left(ImagePathDto(
              path: '',
              type: '',
              isSuccess: false,
              message: 'avatar_error_unknown'.tr));
        }, (r) {
          return Right(ImagePathDto(
              path: dataPresignedUrl.data["avatarObjectKey"],
              type: '',
              isSuccess: true,
              message: 'Success'));
        });
      });
    });
  }

  Future<List<ImagePathDto>> uploadMultipleImage(
      BuildContext context, List<ImagePathDto> imageUrl) async {
    List<ImagePathDto> pathResults = [];
    try {
      loading.value = true;
      for (int i = 0; i < imageUrl.length; i++) {
        final String ext = path.extension(imageUrl[i].path);
        GatewayResponse dataPresignedUrl =
            (await _uploadImageApi.getAvatarPresignedUrl(ext.substring(1)))
                .getOrElse(() => GatewayResponse(data: {}));
        await _uploadImageApi.uploadImage(dataPresignedUrl.data["presignedUrl"],
            File(imageUrl[i].path), dataPresignedUrl.data["formData"]);
        pathResults.add(new ImagePathDto(
            path: dataPresignedUrl.data["avatarObjectKey"],
            type: imageUrl[i].type));
      }
      loading.value = false;
      return pathResults;
    } catch (err) {
      loading.value = false;
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

  Future<Either<ImagePathDto, ImagePathDto>> uploadThumbnail(BuildContext context, ImagePathDto imageUrl) async {
    final String ext = path.extension(imageUrl.path);
    final eitherUrl =
    await _uploadImageApi.getThumbnailPresignedUrl(ext.substring(1));
    return eitherUrl.fold((_) {
      return Left(ImagePathDto(
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
        return Left(ImagePathDto(
            path: '', type: '', isSuccess: false, message: msg));
      }, (res) async {
        return Right(ImagePathDto(
            path: dataPresignedUrl.data["liveThumbnailObjectKey"],
            type: '',
            isSuccess: true,
            message: 'Success'));
      });
    });
  }
}
