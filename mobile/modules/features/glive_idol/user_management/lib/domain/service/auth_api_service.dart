import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:user_management/constants/identityType.dart';
import 'package:user_management/domain/entity/image_path/image_path.dart';
import 'package:user_management/domain/entity/request/account-info.dart';
import 'package:user_management/domain/entity/request/otp.dart';
import 'package:user_management/domain/entity/request/reset-password.dart';
import 'package:user_management/domain/entity/response/access_status_response.dart';
import 'package:common_module/common_module.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_management/constants/social_signin_types.dart';
import 'package:user_management/domain/entity/response/login_response.dart';
import 'package:user_management/domain/entity/social_network/external_token.dart';
import 'package:user_management/domain/service/upload_image_service.dart';
import 'package:user_management/domain/usecase/auth/change_password.dart';
import 'package:user_management/domain/usecase/auth/check_existing_user.dart';
import 'package:user_management/domain/usecase/auth/link_account.dart';
import 'package:user_management/domain/usecase/auth/login_using_acount.dart';
import 'package:user_management/domain/usecase/auth/remove_device_info.dart';
import 'package:user_management/domain/usecase/auth/update_device_info.dart';
import 'package:user_management/domain/usecase/auth/update_info_idol.dart';
import 'package:user_management/repository/social_network_id_repository.dart';
import 'package:user_management/domain/usecase/auth/register.dart';
import 'package:user_management/repository/auth_api_repository.dart';
import 'package:user_management/repository/user_info_api_repository.dart';

abstract class AuthApiServiceAbs{
  Future<Either<Failure, LoginResponse>> login({required AccountParams params});
  Future<Either<Failure, LoginResponse>> refreshToken({required String token});
  Future<Either<Failure, GatewayResponse>> CheckExistingUser({required CheckExistingUserParams params});
  Future<Either<Failure, GatewayResponse>> GetOtpResetPassword({required OtpDto otpDto});
  Future<Either<Failure, GatewayResponse>> ResetPassword({required ResettingPasswordDto data});
  Future<Either<Failure, GatewayResponse>> changePassword({required ChangePasswordParams data});
  Future<Either<Failure, LoginResponse>> loginSocialNetwork({required SocialSignInType signInType});
  Future<Either<Failure, bool>> checkExistingUser({required CheckExistingUserParams params});
  Future<Either<Failure, GatewayResponse>> getOtp({required OtpDto otp});
  Future<Either<Failure, bool>> verifyOtp({required OtpDto otp});
  Future<Either<Failure, GatewayResponse>> register({required RegisterParams params});
  Future<Either<Failure, bool>> updateInfoIdol({required AccountDto account});
  Future<Either<Failure, AccessStatusResponse>> checkAccessStatusUser();
  Future<Either<Failure, bool>> updateInfoForIdol({required InfoParams params});
  Future<Either<Failure, GatewayResponse>> updateDeviceInfo(DeviceInfoParams params);
  Future<Either<Failure, GatewayResponse>> removeDeviceInfo(RemoveInfoParams params);
  Future<Either<Failure, GatewayResponse>> linkAccount({required LinkAccountParams params});
  Future<Either<Failure, GatewayResponse>> linkSocialAccount({required SocialSignInType signInType});
}

class AuthApiService implements AuthApiServiceAbs{
  final logger = Modular.get<Logger>();

  @override
  Future<Either<Failure, LoginResponse>> login(
      {required AccountParams params}) async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.login(params);
    return either.fold((failure) => Left(failure), (data) {
      return Right(LoginResponse.fromMap(data.data));
    });
  }

  @override
  Future<Either<Failure, LoginResponse>> refreshToken({required String token}) async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.refreshToken(token);
    return either.fold((failure) => Left(failure), (data) {
      return Right(LoginResponse.fromMap(data.data));
    });
  }

  @override
  Future<Either<Failure, GatewayResponse>> CheckExistingUser({required CheckExistingUserParams params}) async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.checkExistingUser(params);
    return either.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, GatewayResponse>> GetOtpResetPassword({required OtpDto otpDto}) async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.getOtpResetPassword(otpDto);
    return either.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, GatewayResponse>> ResetPassword(
      {required ResettingPasswordDto data}) async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.resetPassword(data);
    return either.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, GatewayResponse>> changePassword(
      {required ChangePasswordParams data}) async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.changePassword(newPassword: data.newPassword, currentPassword: data.currentPassword);
    return either.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, LoginResponse>> loginSocialNetwork(
      {required SocialSignInType signInType}) async {
    final socialRepo = Modular.get<SocialNetworkIdRepository>();
    final authRepo = Modular.get<AuthApiRepository>();
    late Either<Failure, ExternalToken> socialImpl;
    if (signInType == SocialSignInType.google) {
      socialImpl = await socialRepo.loginGoogle();
    }
    if (signInType == SocialSignInType.facebook) {
      socialImpl = await socialRepo.loginFacebook();
    }
    if (signInType == SocialSignInType.apple){
      socialImpl = await socialRepo.loginApple();
    }
    if (signInType == SocialSignInType.zalo){
      socialImpl = await socialRepo.loginZalo();
    }
    return socialImpl.fold((failure) => Left(failure), (externalToken) async {
      final authImpl = await authRepo.loginSocial(externalToken.idToken!, signInType);
      return authImpl.fold((failure) => Left(failure), (data) async {
        if (data.data['username'] != null) {
          SharedPreferenceHelper _shareHelper = SharedPreferenceHelper(await SharedPreferences.getInstance());
          _shareHelper.setRegisteredID(data.data['username']);
        }
        return Right(LoginResponse.fromMap(data.data));
      });
    });
  }

  @override
  Future<Either<Failure, bool>> checkExistingUser({required CheckExistingUserParams params}) async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.checkExistingUser(params);
    return either.fold((failure) => Left(failure), (data) {
      if (data.messageCode == MessageCode.USER_EXIST) {
        return Right(true);
      }
      return Right(false);
    });
  }

  @override
  Future<Either<Failure, GatewayResponse>> getOtp({required OtpDto otp}) async {
    final authRepository = Modular.get<AuthApiRepository>();
    final result = await authRepository.getOtp(otp);
    return result;
  }

  @override
  Future<Either<Failure, bool>> verifyOtp({required OtpDto otp}) async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.verifyOtp(otp);
    return either.fold((failure) => Left(failure), (data) {
      if (data.messageCode == MessageCode.VERIFY_OTP_SUCCESS) {
        return Right(true);
      }
      return Right(false);
    });
  }

  @override
  Future<Either<Failure, GatewayResponse>> register({required RegisterParams params}) async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.register(params);
    return either.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, bool>> updateInfoIdol({required AccountDto account}) async {
    final userInfoRepo = Modular.get<UserInfoApiRepository>();
    final uploadImageService = UploadImageService();
    List<ImagePath> listImage = [];

    listImage.add(new ImagePath(path: account.photoFront, type: IdentityTypeImage.identityFont));
    if (account.photoBack != '') {
      listImage.add(new ImagePath(path: account.photoBack, type: IdentityTypeImage.identityBack));
    }
    listImage.add(new ImagePath(path: account.portrait, type: IdentityTypeImage.portrait));

    final resultUpload = await uploadImageService.uploadMultipleImage(listImage: listImage);

    return resultUpload.fold((l) => Left(l), (ListPath) async {
      for (int i = 0; i < ListPath.length; i++) {
        if (ListPath[i].type == IdentityTypeImage.identityFont) {
          account.photoFront = ListPath[i].path;
        }
        if (listImage.length == 3 && ListPath[i].type == IdentityTypeImage.identityBack) {
          account.photoBack = ListPath[i].path;
        }
        if (listImage[i].type == IdentityTypeImage.portrait) {
          account.portrait = ListPath[i].path;
        }
      }

      logger.i("identity: ${account.identityNumber} \n"
          "fullName: ${account.fullName} \n"
          "country: ${account.country} \n"
          "gender: ${account.gender} \n"
          "birthdate: ${account.birthdate} \n"
          "province: ${account.province} \n"
          "photoFront: ${account.photoFront} \n"
          "photoBack: ${account.photoBack} \n"
          "portrait: ${account.portrait} \n"
          "type: ${account.type} \n");

      final either = await userInfoRepo.updateAccountInfo(account);
      return either.fold((failure) => Left(failure), (data) {
        return Right(true);
      });
    });
  }

  @override
  Future<Either<Failure, AccessStatusResponse>> checkAccessStatusUser() async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.checkAccessStatusUser();
    return either.fold((failure) => Left(failure), (data) {
      if (data.data != null) {
        return Right(AccessStatusResponse.fromMap(data.data));
      } else {
        return Right(new AccessStatusResponse());
      }
    });
  }

  @override
  Future<Either<Failure, bool>> updateInfoForIdol({required InfoParams params}) async {
    final infoIdolRepo = Modular.get<UserInfoApiRepository>();
    final either = await infoIdolRepo.updateInfoForIdol(params);
    return either.fold((failure) => Left(failure), (data) {
      if (data.messageCode == MessageCode.UPDATE_IDOL_SUCCESS) {
        return Right(true);
      }
      return Right(false);
    });
  }

  @override
  Future<Either<Failure, GatewayResponse>> updateDeviceInfo(DeviceInfoParams params) async {
    final _accountInfoApi = Modular.get<UserInfoApiRepository>();
    final either = await _accountInfoApi.updateDeviceInfo(params);
    return either.fold((failure) => Left(failure), (data) {
        return Right(data);
    });
  }

  @override
  Future<Either<Failure, GatewayResponse>> removeDeviceInfo(RemoveInfoParams params) async {
    final _accountInfoApi = Modular.get<UserInfoApiRepository>();
    final either = await _accountInfoApi.removeDeviceInfo(params);
    return either.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, GatewayResponse>> linkAccount(
      {required LinkAccountParams params}) async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.linkAccount(params);
    return either.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, GatewayResponse>> linkSocialAccount(
      {required SocialSignInType signInType}) async {
    final socialRepo = Modular.get<SocialNetworkIdRepository>();
    final authRepo = Modular.get<AuthApiRepository>();
    late Either<Failure, ExternalToken> socialImpl;
    if (signInType == SocialSignInType.google) {
      socialImpl = await socialRepo.loginGoogle();
    }
    if (signInType == SocialSignInType.facebook) {
      socialImpl = await socialRepo.loginFacebook();
    }
    if (signInType == SocialSignInType.apple){
      socialImpl = await socialRepo.loginApple();
    }
    if (signInType == SocialSignInType.zalo){
      socialImpl = await socialRepo.loginZalo();
    }
    return socialImpl.fold((failure) => Left(failure), (externalToken) async {
      final authImpl = await authRepo.linkSocialAccount(externalToken.idToken!, signInType);
      return authImpl.fold((failure) => Left(failure), (data) async {
        return Right(data);
      });
    });
  }
}
