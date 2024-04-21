import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/dto/reset_password_dto.dart';
import 'package:user_management/controllers/reset_password_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/service/auth_api_service.dart';

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
            resetPasswordStoreController.confirmForgotPassword(context);
          }),
    );
  }


}
