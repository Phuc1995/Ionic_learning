import 'dart:io';

import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/repositorise/upload_image_api_repository.dart';
import 'package:path/path.dart' as p;

abstract class UploadImageServiceAbs{
  Future<Either<Failure, List<ImagePathDto>>> uploadMultipleImage({required List<ImagePathDto> listImage});
}

class UploadImageService implements UploadImageServiceAbs {
  final logger = Modular.get<Logger>();

  @override
  Future<Either<Failure, List<ImagePathDto>>> uploadMultipleImage(
      {required List<ImagePathDto> listImage}) async {
    final uploadImageRepo = Modular.get<UploadImageApiRepository>();
    List<ImagePathDto> pathResults = [];

    for (int i = 0; i < listImage.length; i++) {
      final String ext = p.extension(listImage[i].path);
      final dataPresignedUrl = await uploadImageRepo.getImagePresignedUrl(ext, listImage[i].type);
      dataPresignedUrl.fold((l) => null, (dataPresignedUrl) async {
        pathResults.add(new ImagePathDto(
            path: dataPresignedUrl.data["avatarObjectKey"],
            type: listImage[i].type));
        await uploadImageRepo.uploadImage(dataPresignedUrl.data["presignedUrl"],
            File(listImage[i].path), dataPresignedUrl.data["formData"]).then((data){
              data.fold((failure) => logger.e(failure), (r) => null);
        });
      });
    }

    return Right(pathResults);
  }
}
