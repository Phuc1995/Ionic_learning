import 'package:common_module/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:user_management/domain/entity/social_network/external_token.dart';

abstract class SocialNetworkIdRepository{

  Future<Either<Failure, ExternalToken>> loginFacebook();

  Future<Either<Failure, ExternalToken>> loginGoogle();

  Future<Either<Failure, ExternalToken>> loginApple();

  Future<Either<Failure, ExternalToken>> loginZalo();
}