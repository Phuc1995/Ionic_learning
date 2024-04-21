import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:user_management/constants/social_signin_types.dart';
import 'package:user_management/domain/entity/request/otp.dart';
import 'package:user_management/domain/entity/request/reset-password.dart';
import 'package:user_management/domain/usecase/auth/check_existing_user.dart';
import 'package:user_management/domain/usecase/auth/link_account.dart';
import 'package:user_management/domain/usecase/auth/login_using_acount.dart';
import 'package:user_management/domain/usecase/auth/register.dart';

abstract class AuthApiRepository {
  Future<Either<Failure,GatewayResponse>> login(AccountParams params);

  Future<Either<Failure,GatewayResponse>> loginSocial(String idToken, SocialSignInType type);

  Future<Either<Failure,GatewayResponse>> refreshToken(String refreshToken);

  Future<Either<Failure,GatewayResponse>> checkExistingUser(CheckExistingUserParams params);

  Future<Either<Failure,GatewayResponse>> getOtp(OtpDto otpDto);

  Future<Either<Failure,GatewayResponse>> verifyOtp(OtpDto otpDto);

  Future<Either<Failure,GatewayResponse>> register(RegisterParams params);

  Future<Either<Failure,GatewayResponse>> getOtpResetPassword(OtpDto otpDto);

  Future<Either<Failure,GatewayResponse>> resetPassword(ResettingPasswordDto resetPasswordParams);

  Future<Either<Failure,GatewayResponse>> changePassword({required String newPassword, String? currentPassword});

  Future<Either<Failure,GatewayResponse>> checkAccessStatusUser();

  Future<Either<Failure,GatewayResponse>> linkAccount(LinkAccountParams params);

  Future<Either<Failure,GatewayResponse>> linkSocialAccount(String idToken, SocialSignInType type);

}
