import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/domain/entity/response/login_response.dart';
import 'package:user_management/domain/service/auth_api_service.dart';

class RefreshToken extends UseCase<LoginResponse, String> {
  late Either<Failure, LoginResponse> _response;

  Either<Failure, LoginResponse> get response => _response;

  @override
  Future<Either<Failure, LoginResponse>> call(String token) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.refreshToken(token: token);
    return _response;
  }
}

