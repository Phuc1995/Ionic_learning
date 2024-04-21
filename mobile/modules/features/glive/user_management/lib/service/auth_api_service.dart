import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_management/constants/social_signin_types.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/repositorise/auth_api_repository.dart';
import 'package:user_management/repositorise/repositories.dart';
import 'package:user_management/repositorise/user_info_api_repository.dart';

class AuthApiService {
  final logger = Modular.get<Logger>();

  @override
  Future<Either<Failure, LoginResponseDto>> loginWithAccount(
      {required AccountParamsDto params}) async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.login(params);
    return either.fold((failure) => Left(failure), (data) {
      return Right(LoginResponseDto.fromMap(data.data));
    });
  }

  @override
  Future<Either<Failure, LoginResponseDto>> refreshToken({required String token}) async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.refreshToken(token);
    return either.fold((failure) => Left(failure), (data) {
      return Right(LoginResponseDto.fromMap(data.data));
    });
  }

  @override
  Future<Either<Failure, GatewayResponse>> CheckExistingUser({required CheckExistingUserParamsDto params}) async {
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
  Future<Either<Failure, GatewayResponse>> resetPassword(
      {required ResettingPasswordDto data}) async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.resetPassword(data);
    return either.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, GatewayResponse>> changePassword(
      {required ChangePasswordParamsDto data}) async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.changePassword(newPassword: data.newPassword, currentPassword: data.currentPassword);
    return either.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, LoginResponseDto>> loginSocialNetwork(
      {required SocialSignInType signInType}) async {
    final socialRepo = Modular.get<SocialNetworkIdRepository>();
    final authRepo = Modular.get<AuthApiRepository>();
    late Either<Failure, ExternalTokenDto> socialImpl;
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
        return Right(LoginResponseDto.fromMap(data.data));
      });
    });
  }

  @override
  Future<Either<Failure, bool>> checkExistingUser({required CheckExistingUserParamsDto params}) async {
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
  Future<Either<Failure, GatewayResponse>> register({required RegisterParamsDto params}) async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.register(params);
    return either.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, bool>> updateInfoViewer({required AccountDto account}) async {
    final userInfoRepo = Modular.get<UserInfoApiRepository>();
    final either = await userInfoRepo.updateAccountInfo(account);
    return either.fold((failure) => Left(failure), (data) {
      return Right(true);
    });
  }

  @override
  Future<Either<Failure, AccessStatusResponseDto>> checkAccessStatusUser() async {
    final authRepository = Modular.get<AuthApiRepository>();
    final either = await authRepository.checkAccessStatusUser();
    return either.fold((failure) => Left(failure), (data) {
      if (data.data != null) {
        return Right(AccessStatusResponseDto.fromMap(data.data));
      } else {
        return Right(new AccessStatusResponseDto());
      }
    });
  }

  @override
  Future<Either<Failure, bool>> updateViewerInfo({required InfoParamsDto params}) async {
    final infoIdolRepo = Modular.get<UserInfoApiRepository>();
    final either = await infoIdolRepo.updateViewerInfo(params);
    return either.fold((failure) => Left(failure), (data) {
      if (data.messageCode == MessageCode.UPDATE_IDOL_SUCCESS) {
        return Right(true);
      }
      return Right(false);
    });
  }

  @override
  Future<Either<Failure, GatewayResponse>> updateDeviceInfo(DeviceInfoParamDto params) async {
    final _accountInfoApi = Modular.get<UserInfoApiRepository>();
    final either = await _accountInfoApi.updateDeviceInfo(params);
    return either.fold((failure) => Left(failure), (data) {
        return Right(data);
    });
  }

  @override
  Future<Either<Failure, GatewayResponse>> removeDeviceInfo(RemoveInfoParamsDto params) async {
    final _accountInfoApi = Modular.get<UserInfoApiRepository>();
    final either = await _accountInfoApi.removeDeviceInfo(params);
    return either.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }


  @override
  Future<Either<Failure, GatewayResponse>> linkAccount(
      {required LinkAccountParamsDto params}) async {
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
    late Either<Failure, ExternalTokenDto> socialImpl;
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
