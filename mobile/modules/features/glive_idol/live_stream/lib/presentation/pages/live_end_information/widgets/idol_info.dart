import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IdolInfoWidget extends StatelessWidget {
  final String nickName;
  final String gliveId;
  final TextAlign textAlign;
  final double bottom;

  const IdolInfoWidget({
    Key? key,
    required this.nickName,
    required this.gliveId,
    this.bottom = 15,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(gliveId,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 22.sp,
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            'home_nickname'.tr + ": " + nickName,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: ConvertCommon().hexToColor("#8A8A8A"),
              fontSize: 14.sp,
            ),
          ),
        )
      ],
    );
  }
}
