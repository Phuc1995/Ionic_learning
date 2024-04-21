import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainTitleWidget extends StatelessWidget {
  final String title;
  final TextAlign textAlign;
  final double bottom;

  const MainTitleWidget({
    Key? key,
    required this.title,
    this.bottom = 15,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 25.h, 0, 40.h),
      child: Column(children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title.tr,
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.5.h,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ]),
    );
  }
}
