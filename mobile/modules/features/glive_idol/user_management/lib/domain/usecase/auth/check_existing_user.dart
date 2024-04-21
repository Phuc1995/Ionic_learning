import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/domain/service/auth_api_service.dart';

class CheckExistingUser extends UseCase<bool, CheckExistingUserParams> {
  late Either<Failure, bool> _response;

  Either<Failure, bool> get response => _response;

  @override
  Future<Either<Failure, bool>> call(CheckExistingUserParams params) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.checkExistingUser(params: params);
    return _response;
  }
}

class CheckExistingUserParams extends Equatable {
  final bool loginWithPhone;
  final String phoneCode;
  final String phone;
  final String email;

  @override
  List<Object> get props => [loginWithPhone, phoneCode, phone, email];

  CheckExistingUserParams({this.loginWithPhone = false, this.phoneCode = '', this.phone = '', this.email = ''});
}
