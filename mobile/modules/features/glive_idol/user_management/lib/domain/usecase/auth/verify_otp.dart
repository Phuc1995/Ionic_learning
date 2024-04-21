import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/domain/entity/request/otp.dart';
import 'package:user_management/domain/service/auth_api_service.dart';

class VerifyOtp extends UseCase<bool, OtpDto> {
  late Either<Failure, bool> _response;

  Either<Failure, bool> get response => _response;

  @override
  Future<Either<Failure, bool>> call(OtpDto otp) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.verifyOtp(otp: otp);
    return _response;
  }
}

