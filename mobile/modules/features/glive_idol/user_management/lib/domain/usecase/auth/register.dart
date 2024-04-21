import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/domain/service/auth_api_service.dart';

class Register extends UseCase<GatewayResponse, RegisterParams> {
  late Either<Failure, GatewayResponse> _response;

  Either<Failure, GatewayResponse> get response => _response;

  @override
  Future<Either<Failure, GatewayResponse>> call(RegisterParams params) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.register(params: params);
    return _response;
  }
}

class RegisterParams extends Equatable {
  final bool loginWithPhone;
  final String email;
  final String phoneCode;
  final String phone;
  final String password;
  final String verifyCode;

  @override
  List<Object> get props => [loginWithPhone, email, phoneCode, phone, password, verifyCode];

  RegisterParams({this.loginWithPhone = false, this.email = '', this.phoneCode = '', this.phone = '', required this.password, required this.verifyCode});
}

