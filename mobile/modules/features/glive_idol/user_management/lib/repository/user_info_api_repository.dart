import 'dart:io';

import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:user_management/domain/entity/request/account-info.dart';
import 'package:user_management/domain/usecase/auth/remove_device_info.dart';
import 'package:user_management/domain/usecase/auth/update_device_info.dart';
import 'package:user_management/domain/usecase/auth/update_info_idol.dart';

abstract class UserInfoApiRepository {
  Future<Either<Failure, GatewayResponse>> updateAccountInfo(AccountDto? accountInfo);
  Future<Either<Failure, GatewayResponse>> getAvatarPresignedUrl(String filePath, String type);
  Future<Either<Failure, bool>> uploadImage(String presignedUrl, File file, formData);
  Future<Either<Failure, GatewayResponse>> fetchProfile();
  Future<Either<Failure, GatewayResponse>> getAccessStatus();
  Future<Either<Failure, GatewayResponse>> updateInfoForIdol(InfoParams params);
  Future<Either<Failure, GatewayResponse>> updateDeviceInfo(DeviceInfoParams params);
  Future<Either<Failure, GatewayResponse>> removeDeviceInfo(RemoveInfoParams params);

  //skills
  Future<Either<Failure, GatewayResponse>> updateSkillsIdol(String skills);
  Future<Either<Failure, GatewayResponse>> getSkillIdol();
  Future<Either<Failure, GatewayResponse>> getAllSkill();
}
