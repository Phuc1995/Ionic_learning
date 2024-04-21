import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:user_management/dto/profile_response_dto.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:user_management/presentation/page/setting_page/link_account_setting_page/widget/link_account_item.dart';
import 'package:user_management/service/auth_api_service.dart';
import 'package:user_management/constants/social_signin_types.dart';

class SocialAccountWidget extends StatelessWidget {
  final UserStoreController userStoreController;
  final ProfileResponseDto profile;
  final VoidCallback? onSuccess;

  const SocialAccountWidget(
      {Key? key, required this.userStoreController, required this.profile, this.onSuccess})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authService = Modular.get<AuthApiService>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 6),
        child: Text('link_account_social'.tr,
            style: TextUtils.textStyle(FontWeight.w500, 18.sp)),
      ),
      LinkAccountItem(
          icon: Image.asset(Assets.logoGoogle),
          label: 'Google',
          isLinked: this.profile.googleId.isNotEmpty,
          onPressed: () async {
            if (this.profile.googleId.isEmpty) {
              userStoreController.errorMessage.value = "";
              userStoreController.isLoading.value = true;
              String errMessage = "login_error_google_failed".tr;
              final response = await _authService.linkSocialAccount(signInType: SocialSignInType.google);
              _handleLogin(response, context, errMessage);
              userStoreController.isLoading.value = false;
            } else {
              // TODO Disconnect screen
            }
          }),
      LinkAccountItem(
          icon: Image.asset(Assets.logoFacebook),
          label: 'Facebook',
          isLinked: this.profile.facebookId.isNotEmpty,
          onPressed: () async {
            if (this.profile.facebookId.isEmpty) {
              userStoreController.errorMessage.value = "";
              userStoreController.isLoading.value = true;
              String errMessage = "login_error_fb_failed".tr;
              final response = await _authService.linkSocialAccount(signInType: SocialSignInType.facebook);
              _handleLogin(response, context, errMessage);
              userStoreController.isLoading.value = false;
            } else {
              // TODO Disconnect screen
            }
          }),
      LinkAccountItem(
          icon: Image.asset(Assets.logoApple),
          label: 'Apple',
          isLinked: this.profile.appleId.isNotEmpty,
          onPressed: () async {
            if (this.profile.appleId.isEmpty) {
              userStoreController.errorMessage.value = "";
              userStoreController.isLoading.value = true;
              String errMessage = "login_error_apple_failed".tr;
              final response = await _authService.linkSocialAccount(signInType: SocialSignInType.apple);
              _handleLogin(response, context, errMessage);
              userStoreController.isLoading.value = false;
            } else {
              // TODO Disconnect screen
            }
          }),
      LinkAccountItem(
          icon: Image.asset(Assets.logoZalo),
          label: 'Zalo',
          isLinked: this.profile.zaloId.isNotEmpty,
          onPressed: () async {
            if (this.profile.zaloId.isEmpty) {
              userStoreController.errorMessage.value = "";
              userStoreController.isLoading.value = true;
              String errMessage = "login_error_zalo_failed".tr;
              final response = await _authService.linkSocialAccount(signInType: SocialSignInType.zalo);
              _handleLogin(response, context, errMessage);
              userStoreController.isLoading.value = false;
            } else {
              // TODO Disconnect screen
            }
          }),
    ]);
  }

  _handleLogin(Either<Failure, GatewayResponse> result, BuildContext context,
      String errMessage) {
    result.fold((failure) {
      if (failure is DioFailure) {
        ShowErrorMessage().show(context: context, message: errMessage.tr);
      }
    }, (loginResponse) {
      if (this.onSuccess != null) this.onSuccess!();
    });
  }
}
