import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildVerifyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16.0.w),
      child: RoundedButtonGradientWidget(
        height: 48.h,
        textSize: 16.sp,
        buttonText: 'account_complete_verify_now'.tr,
        buttonColor: AppColors.pinkGradientButton,
        textColor: Colors.white,
        onPressed: () {
              Modular.to.pushNamed(IdolRoutes.user_management.accountVerifyStep1Screen);
        },
      ),
    );
  }
}
