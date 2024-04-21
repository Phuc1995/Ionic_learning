import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user_management/presentation/controller/user/reset_password_store_controller.dart';

class ForgotPassText extends StatelessWidget {
  final void Function()? onPressed;
  final Color leftColorText;
  final Color rightColorText;
  const ForgotPassText({Key? key, required this.onPressed, this.leftColorText = AppColors.whiteSmoke2, this.rightColorText = AppColors.yellow3}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResetPasswordStoreController _resetPasswordStoreController = Get.put(ResetPasswordStoreController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(()=> Text(
          _resetPasswordStoreController.loginWithPhone.value ? "login_type_text_left_phone".tr : "login_type_text_left_email".tr,
          style: TextUtils.textStyle(FontWeight.w600, 16.sp, color: leftColorText),)),
        Obx(() => InkWell(
          onTap: this.onPressed,
          child: Text(
            _resetPasswordStoreController.loginWithPhone.value ? "forgot_password_by_email".tr : "forgot_password_by_phone".tr,
            style: TextUtils.textStyle(FontWeight.w600, 16.sp, color: rightColorText),),
        ))
      ],
    );
  }
}
