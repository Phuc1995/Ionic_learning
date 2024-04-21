import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsField extends StatelessWidget {
  const TermsField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16.0.h),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: 'login_title_service_terms'.tr,
            style:
            TextStyle(fontSize: 13.sp, color: Colors.white, height: 1.8.h),
            children: <TextSpan>[
              TextSpan(
                  text: ' ' +
                      'login_title_service_terms_sub'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                      decoration: TextDecoration.underline))
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
