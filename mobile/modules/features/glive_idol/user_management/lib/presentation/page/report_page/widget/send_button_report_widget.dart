import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SendReportWidget extends StatelessWidget {
  const SendReportWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 30.h),
      child: RoundedButtonGradientWidget(
          height: 40.h,
          width: 220.w,
          textSize: 16.sp,
          buttonText: 'report_send_button'.tr,
          buttonColor: AppColors.pinkGradientButton,
          textColor: Colors.white,
          onPressed: () async {
          }
      ),
    );
  }

}
