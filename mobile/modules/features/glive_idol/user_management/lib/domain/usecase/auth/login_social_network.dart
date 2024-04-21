import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/constants/social_signin_types.dart';
import 'package:user_management/domain/entity/response/login_response.dart';
import 'package:user_management/domain/service/auth_api_service.dart';

class LoginUsingFacebook extends UseCase<LoginResponse, NoParams> {
  late Either<Failure, LoginResponse> _response;

  Either<Failure, LoginResponse> get response => _response;

  @override
  Future<Either<Failure, LoginResponse>> call(NoParams params) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.loginSocialNetwork(signInType: SocialSignInType.facebook);
    return _response;
  }
}

class LoginUsingGoogle extends UseCase<LoginResponse, NoParams> {
  late Either<Failure, LoginResponse> _response;

  Either<Failure, LoginResponse> get response => _response;

  @override
  Future<Either<Failure, LoginResponse>> call(NoParams params) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.loginSocialNetwork(signInType: SocialSignInType.google);
    return _response;
  }
}

class LoginUsingApple extends UseCase<LoginResponse, NoParams> {
  late Either<Failure, LoginResponse> _response;

  Either<Failure, LoginResponse> get response => _response;

  @override
  Future<Either<Failure, LoginResponse>> call(NoParams params) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.loginSocialNetwork(signInType: SocialSignInType.apple);
    return _response;
  }
}

class LoginUsingZalo extends UseCase<LoginResponse, NoParams> {
  late Either<Failure, LoginResponse> _response;

  Either<Failure, LoginResponse> get response => _response;

  @override
  Future<Either<Failure, LoginResponse>> call(NoParams params) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.loginSocialNetwork(signInType: SocialSignInType.zalo);
    return _response;
  }
}
