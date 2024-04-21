import 'dart:ui';
import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:common_module/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDialogMessage extends StatelessWidget {
  final String title, descriptions, text, subTitle, buttonText, buttonText2;
  final Function onPressed;
  final Function? onPressed2;

  const CustomDialogMessage(
      {Key? key,
        this.title = '',
        this.descriptions = '',
        this.text = '',
        this.subTitle = '',
        required this.buttonText,
        required this.onPressed,
        this.buttonText2 = '',
        this.onPressed2,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(45.r),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
      insetPadding: EdgeInsets.only(left: 40.w, right: 40.w),
    );
  }

  contentBox(context) {
    return Container(
      padding: EdgeInsets.only(left: 40.w, top: 25.h, right: 40.w, bottom: 20.h),
      margin: EdgeInsets.only(top: 40.h, bottom: 40.h),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(color: Colors.black54, blurRadius: 10),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.h,
          ),
          RoundedButtonGradientWidget(
            textSize: 13.sp,
            buttonText: buttonText,
            buttonColor: AppColors.pinkGradientButton,
            textColor: Colors.white,
            width: double.infinity,
            height: 40.h,
            onPressed: () => onPressed(),
          ),
          SizedBox(
            height: 10.h,
          ),
          if(buttonText2 != '') ...[
            RoundedButtonGradientWidget(
              textSize: 13.sp,
              buttonText: buttonText2,
              buttonColor: AppColors.whiteBackground,
              textColor: Colors.grey,
              width: double.infinity,
              height: 40.h,
              border: Border.all(color: ConvertCommon().hexToColor("#EBEBEB")),
              onPressed: () => onPressed2!(),
            ),
          ]
        ],
      ),
    );
  }
}
