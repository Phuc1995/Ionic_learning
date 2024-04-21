import 'package:common_module/common_module.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/controllers/user_store_controller.dart';
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
                              userStoreController.clearTextLogin();
                              String errMessage = "login_error_apple_failed".tr;
                              final response = await userStoreController.loginUsingApple();
                              userStoreController.handleLogin(response, context, errMessage);
                            },),
                          SizedBox(width: 20.w,),
                          InkWell(
                            child: Image.asset(Assets.facebook),
                            onTap: () async {
                              userStoreController.clearTextLogin();
                              String errMessage = "login_error_fb_failed".tr;
                              final response = await userStoreController.loginUsingFacebook();
                              DeviceUtils.hideKeyboard(context);
                              userStoreController.handleLogin(response, context, errMessage);
                            },),
                          SizedBox(width: 20.w,),
                          InkWell(
                            child: Image.asset(Assets.google),
                            onTap: () async {
                              userStoreController.clearTextLogin();
                              String errMessage = "login_error_google_failed".tr;
                              final response = await userStoreController.loginUsingGoogle();
                              DeviceUtils.hideKeyboard(context);
                              userStoreController.handleLogin(response, context, errMessage);
                            },),
                          SizedBox(width: 20.w,),
                          InkWell(
                            child: Image.asset(Assets.zalo),
                            onTap: () async {
                              userStoreController.clearTextLogin();
                              String errMessage = "login_error_zalo_failed".tr;
                              DeviceUtils.hideKeyboard(context);
                              final response = await userStoreController.loginUsingZalo();
                              DeviceUtils.hideKeyboard(context);
                              userStoreController.handleLogin(response, context, errMessage);
                            },),
                        ]
                    )),
              ),
            )
          ],
        ));
  }





}
