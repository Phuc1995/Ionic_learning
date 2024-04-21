import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/domain/entity/response/access_status_response.dart';
import 'package:user_management/domain/entity/response/login_response.dart';
import 'package:user_management/domain/usecase/auth/check_access_status_user.dart';
import 'package:user_management/domain/usecase/auth/login_social_network.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginSocialButton extends StatelessWidget {
  final UserStoreController userStoreController;
  const LoginSocialButton({Key? key, required this.userStoreController}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: EdgeInsets.only(top: 32.h, bottom: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'login_OR'.tr,
              style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 16.h),
                child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            child: Image.asset(Assets.apple),
                            onTap: () async {
                                  userStoreController.errorMessage.value = "";
                                  userStoreController.isLoading.value = true;
                                  userStoreController.isSuccess.value = false;
                                  String errMessage = "login_error_apple_failed".tr;
                                  final response = await LoginUsingApple()(NoParams());
                                  _handleLogin(response, context, errMessage);
                            },),
                          SizedBox(width: 20.w,),
                          InkWell(
                            child: Image.asset(Assets.facebook),
                            onTap: () async {
                                  userStoreController.errorMessage.value = "";
                                  userStoreController.isLoading.value = true;
                                  userStoreController.isSuccess.value = false;
                                  String errMessage = "login_error_fb_failed".tr;
                                  final response = await LoginUsingFacebook()(NoParams());
                                  _handleLogin(response, context, errMessage);
                            },),
                          SizedBox(width: 20.w,),
                          InkWell(
                            child: Image.asset(Assets.google),
                            onTap: () async {
                                  userStoreController.errorMessage.value = "";
                                  userStoreController.isLoading.value = true;
                                  userStoreController.isSuccess.value = false;
                                  String errMessage = "login_error_google_failed".tr;
                                  final response = await LoginUsingGoogle()(NoParams());
                                  DeviceUtils.hideKeyboard(context);
                                  _handleLogin(response, context, errMessage);
                            },),
                          SizedBox(width: 20.w,),
                          InkWell(
                            child: Image.asset(Assets.zalo),
                            onTap: () async {
                                  userStoreController.errorMessage.value = "";
                                  userStoreController.isSuccess.value = false;
                                  String errMessage = "login_error_zalo_failed".tr;
                                  DeviceUtils.hideKeyboard(context);
                                  final response = await LoginUsingZalo()(NoParams());
                                  userStoreController.isLoading.value = true;
                                  _handleLogin(response, context, errMessage);
                            },),
                        ]
                    )),
              ),
            )
          ],
        ));
  }

  _handleLogin(Either<Failure, LoginResponse> result, BuildContext context, String errMessage){
    result.fold((failure) {
      if(failure is NetworkFailure){
        ShowShortMessage().showTop(context: context, message: "no_network".tr);
      }
      if(failure is DioFailure) {
        userStoreController.errorMessage.value = errMessage.tr;
      }
      userStoreController.isSuccess.value = false;
      userStoreController.isLoading.value = false;
      userStoreController.logout();

    }, (loginResponse) async {
      userStoreController.loginSuccess(loginResponse);
      if((loginResponse.isNew) ?? false){
        Modular.to.pushNamed(IdolRoutes.user_management.accountComplete);
      }else{
        final res = await CheckAccessStatusUser()(NoParams());
        _handleBanUser(res,context);
      }
    });
  }

  _handleBanUser(Either<Failure, AccessStatusResponse> result, BuildContext context){
    userStoreController.isLoading.value = false;
    result.fold((failure) {
      if(failure is DioFailure){
        if(failure.messageCode == "ACCOUNT_IS_BANNED"){
          userStoreController.isBan.value = true;
          userStoreController.isSuccess.value = false;
          userStoreController.logout();
        } else {
          userStoreController.errorMessage.value = 'login_error_unknown'.tr;
        }
      } else {
        userStoreController.errorMessage.value = 'login_error_unknown'.tr;
      }
    }, (res) async {
        userStoreController.isSuccess.value = true;
        userStoreController.isLoggedIn.value = true;
    });
  }

}
