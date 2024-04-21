import 'dart:io';
import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:user_management/constants/social_signin_types.dart';
import 'package:user_management/dto/dto.dart';

class AuthApiRepository {
  final String endpoint = '/auth';
  // dio instance
  final DioClient _dioClient;

  AuthApiRepository(this._dioClient);


  // final logger = Modular.get<Logger>();

  // Login:---------------------------------------------------------------------
  //Right() must be return Entity or boolean
  @override
  Future<Either<Failure,GatewayResponse>> login(AccountParamsDto params) async {
    try{
      var body = params.loginWithPhone ? {'phoneCode': params.phoneCode, 'phoneNumber': params.phone, 'password': params.password}
          : {'email': params.email, 'password': params.password};
      final data = await _dioClient.post('$endpoint/login', data: body);
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  // Login with Google:---------------------------------------------------------------------
  @override
  Future<Either<Failure,GatewayResponse>> loginSocial(String idToken, SocialSignInType type) async {
    try{
      final data = await _dioClient.post('$endpoint/login-social', data: {'authorizationCode': idToken, 'type': type.toShortString(), 'platform': Platform.isIOS ? 'ios' : 'android'});
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  // Refresh token:---------------------------------------------------------------------
  @override
  Future<Either<Failure,GatewayResponse>> refreshToken(String refreshToken) async {
    try {
      final data = await _dioClient.post('$endpoint/refresh-token', data: {'refreshToken': refreshToken});
      return Right(GatewayResponse.fromMap(data));
    } catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure,GatewayResponse>> checkExistingUser(CheckExistingUserParamsDto params) async {
    try {
      var body = params.loginWithPhone ? {'phoneCode': params.phoneCode, 'phoneNumber': params.phone}
          : {'email': params.email};
      final data = await _dioClient.post('$endpoint/check-existing-user', data: body);
      return Right(GatewayResponse.fromMap(data));
    } catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  // Get OTP:---------------------------------------------------------------------
  @override
  Future<Either<Failure,GatewayResponse>> getOtp(OtpDto otpDto) async {
    try{
      final data = await _dioClient.post('$endpoint/get-otp/'+ otpDto.type, data: otpDto);
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  // verify OTP:---------------------------------------------------------------------
  @override
  Future<Either<Failure,GatewayResponse>> verifyOtp(OtpDto otpDto) async {
    try{
      final data = await _dioClient.post('$endpoint/verify-otp/'+ otpDto.type, data: otpDto);
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  // Register:---------------------------------------------------------------------
  @override
  Future<Either<Failure,GatewayResponse>> register(RegisterParamsDto params) async {
    try{
      var body = params.loginWithPhone ? {
        'password': params.password, 'verifyCode': params.verifyCode, 'phoneNumber': params.phone, 'phoneCode': params.phoneCode
      }: {
        'email': params.email, 'password': params.password, 'verifyCode': params.verifyCode
      };
      final data = await _dioClient.post('$endpoint/register', data: body);
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  // Get OTP reset password:---------------------------------------------------------------------
  @override
  Future<Either<Failure,GatewayResponse>> getOtpResetPassword(OtpDto otpDto) async {
    try{
      final data = await _dioClient.post('$endpoint/get-otp/password', data: otpDto);
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  // Reset password:---------------------------------------------------------------------
  @override
  Future<Either<Failure,GatewayResponse>> resetPassword(ResettingPasswordDto resetPasswordParams) async {
    try{
      final data = await _dioClient.post('$endpoint/reset-password', data: resetPasswordParams);
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  // Change password:---------------------------------------------------------------------
  @override
  Future<Either<Failure,GatewayResponse>> changePassword({required String newPassword, String? currentPassword}) async {
    try{
      final data = currentPassword == null ? {'newPassword': newPassword}
          : {'currentPassword': currentPassword, 'newPassword': newPassword};
      final res = await _dioClient.post('$endpoint/change-password', data: data);
      return Right(GatewayResponse.fromMap(res));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  // Ban user:---------------------------------------------------------------------
  @override
  Future<Either<Failure,GatewayResponse>> checkAccessStatusUser() async {
    try{
      final data = await _dioClient.get('/profile/access-status');
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure,GatewayResponse>> linkAccount(LinkAccountParamsDto params) async {
    try{
      var body = params.isPhone ? {'phoneCode': params.phoneCode, 'phoneNumber': params.phoneNumber, 'verifyCode': params.verifyCode}
          : {'email': params.email, 'verifyCode': params.verifyCode};
      final data = await _dioClient.post('$endpoint/link-account', data: body);
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure,GatewayResponse>> linkSocialAccount(String idToken, SocialSignInType type) async {
    try{
      final data = await _dioClient.post('$endpoint/link-account/social', data: {'code': idToken, 'type': type.toShortString(), 'platform': Platform.isIOS ? 'ios' : 'android'});
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

}
