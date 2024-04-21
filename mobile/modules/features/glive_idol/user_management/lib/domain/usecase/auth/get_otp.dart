import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/domain/entity/request/otp.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/domain/service/auth_api_service.dart';

class GetOtp extends UseCase<GatewayResponse, OtpDto> {
  late Either<Failure, GatewayResponse> _response;

  Either<Failure, GatewayResponse> get response => _response;

  @override
  Future<Either<Failure, GatewayResponse>> call(OtpDto otp) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.getOtp(otp: otp);
    return _response;
  }
}

