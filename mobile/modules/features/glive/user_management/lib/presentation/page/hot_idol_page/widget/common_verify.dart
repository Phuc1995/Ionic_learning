import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:common_module/common_module.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonVerify {
  Widget nextButton({required BuildContext context, required Function() submit}) {
    return RoundedButtonGradientWidget(
      textSize: 16.sp,
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      buttonText: ('hot_idol_submit_btn').tr,
      buttonColor: AppColors.pinkGradientButton,
      textColor: Colors.white,
      width: double.infinity,
      height: 60.h,
      onPressed: submit,
    );
  }
}
