import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonVerify {
  Widget nextButton({required BuildContext context, required Function() submit}) {
    return RoundedButtonGradientWidget(
      textSize: 16.sp,
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      buttonText: ('account_verify_next_button').tr,
      buttonColor: AppColors.pinkGradientButton,
      textColor: Colors.white,
      width: double.infinity,
      height: 60.h,
      onPressed: () {
          submit();
      },
    );
  }

  Widget moreInfoTitle() {
    return Align(
        alignment: FractionalOffset.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIconWidget(
              image: Assets.termIcon,
              size: 15.sp,
              height: 20.h,
            ),
            SizedBox(width: 10.w),
            Text(('account_verify_checkbox_text').tr,
                style: TextStyle(
                  color: Colors.black26,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ))
          ],
        ));
  }

  Widget titleField({required String title, required String subTitle}) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: Column(children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            (title).tr,
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.5.h,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 8.h),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              (subTitle).tr,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.5.h,
              ),
              textAlign: TextAlign.center,
            ))
      ]),
    );
  }
}
