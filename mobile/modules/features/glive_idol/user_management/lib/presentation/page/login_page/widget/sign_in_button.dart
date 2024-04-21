import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:user_management/domain/entity/response/access_status_response.dart';
import 'package:user_management/domain/entity/response/login_response.dart';
import 'package:user_management/domain/usecase/auth/check_access_status_user.dart';
import 'package:user_management/domain/usecase/auth/login_using_acount.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInButton extends StatelessWidget {
  final UserStoreController userStoreController;
  const SignInButton({Key? key, required this.userStoreController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShowErrorMessage showErrorMessage = ShowErrorMessage();
    final logger = Modular.get<Logger>();
    logger.i("isSuccess: ${userStoreController.isSuccess.value} \n"
        "isLoggedIn: ${userStoreController.isLoggedIn.value} \n");
    return Container(
      padding: EdgeInsets.only(top: 16.0.h),
      child: RoundedButtonGradientWidget(
          height: 48,
          textSize: 16,
          buttonText: 'login_btn_sign_in'.tr,
          buttonColor: AppColors.pinkGradientButton,
          textColor: Colors.white,
          onPressed: () async {
                if (userStoreController.isInvalidInputFields(context) || userStoreController.isPasswordBlank(context)) {
                  return;
                }
                if (userStoreController.canLogin) {
                  DeviceUtils.hideKeyboard(context);
                  userStoreController.errorMessage.value = "";
                  userStoreController.isLoading.value = true;
                  userStoreController.isSuccess.value = false;
                  final result = await LoginUsingAccount().call(AccountParams(
                    loginWithPhone: userStoreController.loginWithPhone.value,
                    password: userStoreController.passwordController.value,
                    email: userStoreController.emailController.value,
                    phoneCode: userStoreController.phoneCodeController.value,
                    phone: userStoreController.phoneController.value,
                  ));
                  _handleLogin(result, context);
                } else {
                  showErrorMessage.show(message: userStoreController.validateUserId(context), context: context,);
                  showErrorMessage.show(message: userStoreController.validatePassword(context), context: context,);
                }
          }
      ),
    );;
  }

  _handleLogin(Either<Failure, LoginResponse> result, BuildContext context){
    result.fold((failure) {
      if(failure is NetworkFailure){
        ShowShortMessage().showTop(context: context, message: "no_network".tr);
      }
      if(failure is DioFailure) {
        String errMessage = 'login_error_unknown'.tr;
        if(failure.statusCode == 401 || failure.statusCode ==400){
          errMessage = userStoreController.loginWithPhone.value ? 'login_phone_error_failed'.tr : 'login_error_failed'.tr;
        }
        if(failure.statusCode == 403 && failure.messageCode == "ACCOUNT_IS_BANNED"){
          userStoreController.isBan.value = true;
          userStoreController.isSuccess.value = false;
          userStoreController.isLoading.value = false;
          userStoreController.isLoggedIn.value = false;
          return;
        }
        userStoreController.errorMessage.value = errMessage;
      }
      userStoreController.isSuccess.value = false;
      userStoreController.isLoading.value = false;
      userStoreController.isLoggedIn.value = false;
    }, (loginResponse) async {
      userStoreController.loginSuccess(loginResponse);
      final res = await CheckAccessStatusUser()(NoParams());
      _handleBanUser(res,context);
    });
  }

  _handleBanUser(Either<Failure, AccessStatusResponse> result, BuildContext context){
    userStoreController.isLoading.value = false;
    result.fold((failure) {
        userStoreController.errorMessage.value = 'login_error_unknown'.tr;
    }, (res) async {
      if(res.banData != null){
        userStoreController.isBan.value = true;
        userStoreController.isSuccess.value = false;
        userStoreController.isLoggedIn.value = false;
      }else{
        userStoreController.isSuccess.value = true;
        userStoreController.isLoggedIn.value = true;
        final logger = Modular.get<Logger>();
        logger.i("isSuccess: ${userStoreController.isSuccess.value} \n"
            "isLoggedIn: ${userStoreController.isLoggedIn.value} \n"
        );
      }
    });
  }
}
