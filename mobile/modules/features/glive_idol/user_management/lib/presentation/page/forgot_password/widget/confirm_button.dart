import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/domain/entity/request/reset-password.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/domain/usecase/auth/reset_password.dart';
import 'package:user_management/presentation/controller/user/reset_password_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmButton extends StatelessWidget {
  final ResetPasswordStoreController resetPasswordStoreController;

  const ConfirmButton({Key? key, required this.resetPasswordStoreController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16.0),
      child: RoundedButtonGradientWidget(
          height: 48.h,
          textSize: 16.sp,
          buttonText: 'forgot_password_confirm'.tr,
          buttonColor: AppColors.pinkGradientButton,
          textColor: Colors.white,
          onPressed: () async {
                if (resetPasswordStoreController.isInvalidInputFields(context) ||
                    resetPasswordStoreController.isPasswordInvalid(context) ||
                    resetPasswordStoreController.isVerifyInvalid(context)) {
                  return;
                }
                DeviceUtils.hideKeyboard(context);
                resetPasswordStoreController.isLoading.value = true;
                ResettingPasswordDto resetPasswordParams = new ResettingPasswordDto();
                if (resetPasswordStoreController.loginWithPhone.value) {
                  resetPasswordParams.phoneCode = resetPasswordStoreController.phoneCodeController.value;
                  resetPasswordParams.phoneNumber = resetPasswordStoreController.phoneController.value;
                } else {
                  resetPasswordParams.email = resetPasswordStoreController.emailController.value;
                }
                resetPasswordParams.password = resetPasswordStoreController.passwordController.value;
                resetPasswordParams.verifyCode = resetPasswordStoreController.verifyController.value;
                final res = await ResetPassword().call(resetPasswordParams);
                _handleChangePass(res, context);
                resetPasswordStoreController.isLoading.value = false;
          }),
    );
    ;
  }

  _handleChangePass(Either<Failure, GatewayResponse> result, BuildContext context) {
    ShowErrorMessage showErrorMessage = ShowErrorMessage();
    result.fold((failure) {
      String errorMessage = 'forgot_password_error_unknown'.tr;
      if (failure is DioFailure && failure.messageCode == MessageCode.INCORRECT_OTP) {
        errorMessage = 'register_incorrect_otp'.tr;
      }
      showErrorMessage.show(
        message: errorMessage,
        context: context,
      );
    }, (GatewayResponse) {
      if (GatewayResponse.messageCode == MessageCode.RESET_PASSWORD_SUCCESS) {
        DeviceUtils.hideKeyboard(context);
        ShowDialog().showMessage(context, "register_change_password_success_message".tr, "account_verify_confirm_button".tr, (){
          Modular.to.pushReplacementNamed(IdolRoutes.user_management.login);
        });
      } else if (GatewayResponse.messageCode == MessageCode.SEND_OTP_TOO_QUICKLY) {
        showErrorMessage.show(
          message: 'request_otp_too_quick'.tr,
          context: context,
        );
      } else {
        showErrorMessage.show(
          message: 'forgot_password_error_unknown'.tr,
          context: context,
        );
      }
    });
  }
}
