import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/domain/entity/request/otp.dart';
import 'package:user_management/domain/entity/request/reset-password.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/domain/service/auth_api_service.dart';
import 'package:user_management/domain/usecase/auth/check_existing_user.dart';

class CheckExistingUserResetPassword extends UseCase<GatewayResponse, CheckExistingUserParams> {
  late Either<Failure, GatewayResponse> _response;

  Either<Failure, GatewayResponse> get response => _response;

  @override
  Future<Either<Failure, GatewayResponse>> call(CheckExistingUserParams params) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.CheckExistingUser(params: params);
    return _response;
  }
}

class GetOtpResetPassword extends UseCase<GatewayResponse, OtpDto> {
  late Either<Failure, GatewayResponse> _response;

  Either<Failure, GatewayResponse> get response => _response;

  @override
  Future<Either<Failure, GatewayResponse>> call(OtpDto otpDto) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.GetOtpResetPassword(otpDto: otpDto);
    return _response;
  }
}

class ResetPassword extends UseCase<GatewayResponse, ResettingPasswordDto> {
  late Either<Failure, GatewayResponse> _response;

  Either<Failure, GatewayResponse> get response => _response;

  @override
  Future<Either<Failure, GatewayResponse>> call(ResettingPasswordDto data) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.ResetPassword(data: data);
    return _response;
  }
}
