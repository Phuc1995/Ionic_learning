import 'package:common_module/common_module.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartLiveButton extends StatelessWidget {

  final Function() onPressed;

  const StartLiveButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: 240.w,
            child: RoundedButtonGradientWidget(
              textSize: 16.sp,
              buttonText: 'live_start'.tr,
              buttonColor: AppColors.pinkGradientButton,
              textColor: Colors.white,
              width: double.infinity,
              height: 60.h,
              onPressed: onPressed,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 24.h, bottom: 8.h),
            child: Align(
              alignment: FractionalOffset.center,
              child: Text(
                'live_live'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
          Container(
            height: 4.h,
            width: 20.w,
            margin: EdgeInsets.only(bottom: 32.h),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(50)))),
          )
        ],
      )
    );
  }
}