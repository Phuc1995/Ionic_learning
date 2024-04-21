import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleField extends StatelessWidget {
  const TitleField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.0.h, bottom: 16.0.h),
      child: Center(
        child: Text(
          'login_title'.tr,
          style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.5.h),
          textAlign: TextAlign.center,
        ),
      ),
    );;
  }
}
