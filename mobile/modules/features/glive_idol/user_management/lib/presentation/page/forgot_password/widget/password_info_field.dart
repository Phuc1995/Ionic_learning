import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordInfoField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.center,
      // child: Center(
      child: Text(
        'forgot_password_sub_title'.tr,
        style: TextStyle(
          color: Colors.black26,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
