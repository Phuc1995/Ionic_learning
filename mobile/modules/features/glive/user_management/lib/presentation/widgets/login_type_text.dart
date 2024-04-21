import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/user_store_controller.dart';

class LoginTypeText extends StatelessWidget {
  final void Function()? onPressed;
  final Color leftColorText;
  final Color rightColorText;
  final bool isRegister;
  const LoginTypeText({Key? key, required this.onPressed, this.leftColorText = AppColors.whiteSmoke2, this.rightColorText = AppColors.yellow3, this.isRegister = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserStoreController _userStoreController = Get.put(UserStoreController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(()=> Text(
          _userStoreController.loginWithPhone.value ? "login_type_text_left_phone".tr : "login_type_text_left_email".tr,
          style: TextUtils.textStyle(FontWeight.w600, 16.sp, color: leftColorText),)),
        Obx(() => InkWell(
          onTap: this.onPressed,
          child: Text(
            isRegister ?
            _userStoreController.loginWithPhone.value ? "register_type_text_right_email".tr : "register_type_text_right_phone".tr :
            _userStoreController.loginWithPhone.value ? "login_type_text_right_email".tr : "login_type_text_right_phone".tr,
            style: TextUtils.textStyle(FontWeight.w600, 16.sp, color: rightColorText),),
        ))
      ],
    );
  }
}
