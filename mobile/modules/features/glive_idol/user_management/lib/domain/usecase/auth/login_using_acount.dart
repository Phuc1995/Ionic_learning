import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/domain/entity/response/login_response.dart';
import 'package:user_management/domain/service/auth_api_service.dart';

//Controller will call to UseCase and receive the data for
class LoginUsingAccount extends UseCase<LoginResponse, AccountParams> {
  late Either<Failure, LoginResponse> _response;

  Either<Failure, LoginResponse> get response => _response;

  @override
  Future<Either<Failure, LoginResponse>> call(AccountParams params) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.login(params: params);
    return _response;
  }
}

//the param from controllers
class AccountParams extends Equatable {
  final bool loginWithPhone;
  final String phoneCode;
  final String phone;
  final String email;
  final String password;

  @override
  List<Object> get props => [loginWithPhone, phoneCode, phone, email, password];

  AccountParams({this.loginWithPhone = false, this.phoneCode = '', this.phone = '', this.email = '', required this.password});
}
