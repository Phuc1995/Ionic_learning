import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/constants/social_signin_types.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/domain/service/auth_api_service.dart';

class LinkAccountFacebook extends UseCase<GatewayResponse, NoParams> {
  late Either<Failure, GatewayResponse> _response;

  Either<Failure, GatewayResponse> get response => _response;

  @override
  Future<Either<Failure, GatewayResponse>> call(NoParams params) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.linkSocialAccount(signInType: SocialSignInType.facebook);
    return _response;
  }
}

class LinkAccountGoogle extends UseCase<GatewayResponse, NoParams> {
  late Either<Failure, GatewayResponse> _response;

  Either<Failure, GatewayResponse> get response => _response;

  @override
  Future<Either<Failure, GatewayResponse>> call(NoParams params) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.linkSocialAccount(signInType: SocialSignInType.google);
    return _response;
  }
}

class LinkAccountApple extends UseCase<GatewayResponse, NoParams> {
  late Either<Failure, GatewayResponse> _response;

  Either<Failure, GatewayResponse> get response => _response;

  @override
  Future<Either<Failure, GatewayResponse>> call(NoParams params) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.linkSocialAccount(signInType: SocialSignInType.apple);
    return _response;
  }
}

class LinkAccountZalo extends UseCase<GatewayResponse, NoParams> {
  late Either<Failure, GatewayResponse> _response;

  Either<Failure, GatewayResponse> get response => _response;

  @override
  Future<Either<Failure, GatewayResponse>> call(NoParams params) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.linkSocialAccount(signInType: SocialSignInType.zalo);
    return _response;
  }
}
