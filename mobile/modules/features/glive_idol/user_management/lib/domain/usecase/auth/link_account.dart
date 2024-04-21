import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/domain/service/auth_api_service.dart';

//Controller will call to UseCase and receive the data for
class LinkAccount extends UseCase<GatewayResponse, LinkAccountParams> {
  late Either<Failure, GatewayResponse> _response;

  Either<Failure, GatewayResponse> get response => _response;

  @override
  Future<Either<Failure, GatewayResponse>> call(LinkAccountParams params) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.linkAccount(params: params);
    return _response;
  }
}

//the param from controllers
class LinkAccountParams extends Equatable {
  final bool isPhone;
  final String phoneCode;
  final String phoneNumber;
  final String email;
  final String verifyCode;

  @override
  List<Object> get props => [isPhone, phoneCode, phoneNumber, email, verifyCode];

  LinkAccountParams({this.isPhone = false, this.phoneCode = '', this.phoneNumber = '', this.email = '', this.verifyCode = ''});
}
