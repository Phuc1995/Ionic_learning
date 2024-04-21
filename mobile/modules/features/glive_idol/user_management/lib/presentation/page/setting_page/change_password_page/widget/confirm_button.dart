import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/domain/usecase/auth/change_password.dart';
import 'package:user_management/presentation/controller/user/change_password_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmButton extends StatelessWidget {
  final ChangePasswordStoreController changePasswordStoreController;

  const ConfirmButton({Key? key, required this.changePasswordStoreController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16.0),
      child: RoundedButtonGradientWidget(
          height: 48.h,
          textSize: 16.sp,
          buttonText: 'change_password_confirm'.tr,
          buttonColor: AppColors.pinkGradientButton,
          textColor: Colors.white,
          onPressed: () async {
                if (!changePasswordStoreController.validate()) {
                  return;
                }
                DeviceUtils.hideKeyboard(context);
                changePasswordStoreController.isLoading.value = true;
                final isCreatePassword = changePasswordStoreController.isCreatePassword.value;
                ChangePasswordParams params = ChangePasswordParams(
                  newPassword: changePasswordStoreController.newPasswordController.value,
                  currentPassword: isCreatePassword ? null : changePasswordStoreController.passwordController.value,
                );
                final res = await ChangePassword().call(params);
                _handleChangePass(res, context);
                changePasswordStoreController.isLoading.value = false;
          }),
    );
  }

  _handleChangePass(Either<Failure, GatewayResponse> result, BuildContext context) {
    ShowErrorMessage showErrorMessage = ShowErrorMessage();
    result.fold((failure) {
      DeviceUtils.hideKeyboard(context);
      String errorMessage = 'change_password_error_unknown'.tr;
      if (failure is DioFailure) {
        if (failure.messageCode == MessageCode.PASSWORD_INCORRECT) {
          changePasswordStoreController.invalidPasswordMsg.value = 'change_password_password_incorrect'.tr;
          return;
        }
        if (failure.messageCode == MessageCode.USER_NOT_FOUND) {
          ShowDialog().showMessage(context, "change_password_user_not_found".tr, "button_close".tr, (){
            Modular.to.pushReplacementNamed(IdolRoutes.user_management.login);
          });
          return;
        }
      }
      showErrorMessage.show(
        message: errorMessage,
        context: context,
      );
    }, (res) {
      DeviceUtils.hideKeyboard(context);
      Get.delete<ChangePasswordStoreController>();
      ShowDialog().showMessage(context, "change_password_success".tr, "button_close".tr, (){
        Modular.to.pop();
        Modular.to.pop();
      });
    });
  }
}
