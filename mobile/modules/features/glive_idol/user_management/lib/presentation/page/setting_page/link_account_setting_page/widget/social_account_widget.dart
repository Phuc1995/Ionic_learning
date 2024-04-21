import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/assets.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';
import 'package:user_management/domain/usecase/auth/link_social_account.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:user_management/presentation/page/setting_page/link_account_setting_page/widget/link_account_item.dart';

class SocialAccountWidget extends StatelessWidget {
  final UserStoreController userStoreController;
  final ProfileResponse profile;
  final VoidCallback? onSuccess;

  const SocialAccountWidget(
      {Key? key, required this.userStoreController, required this.profile, this.onSuccess})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              final response = await LinkAccountGoogle()(NoParams());
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
              final response = await LinkAccountFacebook()(NoParams());
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
              final response = await LinkAccountApple()(NoParams());
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
              final response = await LinkAccountZalo()(NoParams());
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
