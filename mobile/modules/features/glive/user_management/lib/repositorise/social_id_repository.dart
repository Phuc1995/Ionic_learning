import 'dart:io';

import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:user_management/dto/dto.dart';
import 'package:zalo_flutter/zalo_flutter.dart';

class SocialNetworkIdRepository {
  final logger = Modular.get<Logger>();

  @override
  Future<Either<Failure, ExternalTokenDto>> loginFacebook() async {
    bool ok = await NetworkUtil.checkConnectivity();
    if (!ok) {
      return Left(NetworkFailure());
    }
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(loginBehavior: LoginBehavior.dialogOnly);
      String? _registeredID;
      String? _idToken;
      if (result.status == LoginStatus.success) {
        // you are logged
        final String accessToken = result.accessToken!.token;
        dynamic data = await FacebookAuth.instance.getUserData();
        FacebookInfoResponseDto info = FacebookInfoResponseDto.fromMap(data);
        _registeredID = info.id;
        _idToken = accessToken;
      }
      return Right(ExternalTokenDto(
        idToken: _idToken,
        registerId: _registeredID!,
      ));

    } catch (ex) {
      logger.e('Cannot get credential from Facebook ', ex);
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, ExternalTokenDto>> loginGoogle() async {
    bool ok = await NetworkUtil.checkConnectivity();
    if (!ok) {
      return Left(NetworkFailure());
    }
    late GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId: Platform.isAndroid ? dotenv.env['GOOGLE_CLIENT_ID'] : null,
      scopes: <String>['email', 'profile', 'openid'],
    );
    String? _registeredID;
    String? _idToken;
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await account.authentication;
        if (googleAuth.idToken!.isNotEmpty) {
          _registeredID = account.email;
          _idToken = googleAuth.idToken!;
        }
      } else return Left(LocalFailure());
      return Right(ExternalTokenDto(
        idToken: _idToken,
        registerId: _registeredID!,
      ));
    } on PlatformException catch (ex) {
      logger.e('Cannot get credential from Google ', ex);
      if(ex.code == 'network_error'){
        return Left(NetworkFailure());
      }
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, ExternalTokenDto>> loginApple() async {
    bool ok = await NetworkUtil.checkConnectivity();
    if (!ok) {
      return Left(NetworkFailure());
    }
    String? _registeredID;
    String? _idToken;
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: dotenv.env['APPLE_CLIENT_ID']??'',
          redirectUri: Uri.parse(
            dotenv.env['APPLE_CALLBACK_URI']??'',
          ),
        ),
      );
      _idToken = credential.authorizationCode;
      _registeredID = credential.identityToken;
      return Right(ExternalTokenDto(
        idToken: _idToken,
        registerId: _registeredID!,
      ));
    } catch (ex) {
      logger.e('Cannot get credential from Apple ', ex);
      return Left(LocalFailure());
    }
  }

  Future<Either<Failure, ExternalTokenDto>> loginZalo() async {
    bool ok = await NetworkUtil.checkConnectivity();
    if (!ok) {
      return Left(NetworkFailure());
    }
    String? _registeredID;
    String? _idToken;
    String? _refreshToken;
    try {
      final Map<dynamic, dynamic>? data = await ZaloFlutter.login(
        refreshToken: _refreshToken,
      );
      if (data?['isSuccess'] == true) {
        _idToken = data?["data"]["accessToken"] as String?;
        _registeredID = data?["data"]["accessToken"] as String?;
      } else {
        return Left(LocalFailure());
      }
      return Right(ExternalTokenDto(
        idToken: _idToken,
        registerId: _registeredID!,
      ));
    } catch (ex) {
      logger.e('Cannot get credential from Zalo ', ex);
      return Left(LocalFailure());
    }
  }
}
