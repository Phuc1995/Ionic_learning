import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextInfo extends StatelessWidget {
  const TextInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildText("level_privilege".tr, "level_privilege_1".tr,"level_privilege_2".tr),
        Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: _buildText("level_up".tr, "level_up_1".tr,"level_up_2".tr)),
      ],
    );
  }

  Widget _buildText(String text1, String text2, String text3) {
    return Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              text1,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17.sp,
                color: ConvertCommon().hexToColor("#3A3A3A"),
              ),
            )),
        Padding(
          padding: EdgeInsets.only(left: 5.w, top: 15.h),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                text2,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15.sp,
                  color: ConvertCommon().hexToColor("#3A3A3A"),
                ),
              )),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.w, top: 15.h),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                text3,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15.sp,
                  color: ConvertCommon().hexToColor("#3A3A3A"),
                ),
              )),
        ),
      ],
    );
  }
}
