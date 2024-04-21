import 'package:flutter/material.dart';
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
    return Padding(
      padding: EdgeInsets.only(bottom: bottom.h),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.sp),
        textAlign: textAlign,
      ),
    );
  }
}
