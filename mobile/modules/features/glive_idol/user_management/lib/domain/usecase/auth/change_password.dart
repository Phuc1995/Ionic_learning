import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/domain/service/auth_api_service.dart';

class ChangePassword extends UseCase<GatewayResponse, ChangePasswordParams> {
  late Either<Failure, GatewayResponse> _response;

  Either<Failure, GatewayResponse> get response => _response;

  @override
  Future<Either<Failure, GatewayResponse>> call(ChangePasswordParams params) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.changePassword(data: params);
    return _response;
  }
}

class ChangePasswordParams extends Equatable {
  String? currentPassword;
  String newPassword;

  @override
  List<String?> get props => [currentPassword, newPassword];

  ChangePasswordParams({this.currentPassword, required this.newPassword});
}
