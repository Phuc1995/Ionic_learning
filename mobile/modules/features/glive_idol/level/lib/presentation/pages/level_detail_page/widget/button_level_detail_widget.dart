import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonLevelDetailWidget extends StatelessWidget {
  const ButtonLevelDetailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedButtonGradientWidget(
      buttonText: 'level_detail_level_up'.tr,
      buttonColor: AppColors.pinkGradientButton,
      textColor: Colors.white,
      width: double.infinity,
      height: 60.h,
      onPressed: (){

      }, textSize: 16.sp,
    );
  }
}
