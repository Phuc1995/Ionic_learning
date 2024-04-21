import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/change_password_store_controller.dart';
import 'package:user_management/dto/dto.dart';
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
            ChangePasswordParamsDto params = ChangePasswordParamsDto(
              newPassword: changePasswordStoreController.newPasswordController.value,
              currentPassword: isCreatePassword ? null : changePasswordStoreController.passwordController.value,
            );
            final res = await changePasswordStoreController.changePassword(params);
            changePasswordStoreController.handleChangePass(res, context);
          }),
    );
  }
}
