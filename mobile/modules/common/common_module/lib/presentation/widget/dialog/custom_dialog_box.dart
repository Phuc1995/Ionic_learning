import 'dart:ui';
import 'package:common_module/common_module.dart';
import 'package:common_module/presentation/widget/button/rounded_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:common_module/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomDialogBox extends StatelessWidget {
  final String title, descriptions, text, subTitle, buttonText;
  final AppIconWidget imgIcon;
  final Function onPressed;

  const CustomDialogBox(
      {Key? key,
      this.title = '',
      this.descriptions = '',
      this.text = '',
      this.subTitle = '',
      required this.buttonText,
      required this.imgIcon,
      required this.onPressed})
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
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20.w, top: 64.h, right: 20.w, bottom: 20.h),
          margin: EdgeInsets.only(top: 40.h, bottom: 40.h),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(color: Colors.black54, blurRadius: 10.r),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: subTitle != '' ? 8.h : 0,
              ),
              subTitle != ''
                  ? Text(
                subTitle,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              )
                  : Container(),
              SizedBox(
                height: descriptions != '' ? 12.sp : 0,
              ),
              descriptions != ''
                  ? Text(
                descriptions,
                style: TextStyle(fontSize: 14.sp),
                textAlign: TextAlign.center,
              )
                  : Container(),
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        ),
        Positioned(
          left: 20.w,
          right: 20.w,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45.r,
            child:
            ClipRRect(borderRadius: BorderRadius.all(Radius.circular(30.r)), child: imgIcon),
          ),
        ),
        Positioned(
          bottom: 20.h,
          left: 20.w,
          right: 20.w,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: RoundedButtonWidget(
              textSize: 14.sp,
              fontWeight: FontWeight.w600,
              buttonText: buttonText,
              buttonColor: AppColors.whiteSmoke4,
              onPressed: () => onPressed(),
              textColor: Colors.black,
              height: 42.h,
              width: 130.w,
            ),
          ),
        ),
      ],
    );
  }
}
