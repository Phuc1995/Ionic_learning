import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContentStep4Verify extends StatelessWidget {
  const ContentStep4Verify({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '* ' + ('account_verify_4_note').tr,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.w),
              width: 280.w,
              height: 1.h,
              color: Colors.black12,
            )
          ],
        ),
        _buildContentParaphrase(('account_verify_4_title_1').tr, isFirtText: true),
        _buildContentParaphrase(('account_verify_4_title_2').tr, isFirtText: false),
        _buildContentParaphrase(('account_verify_4_title_3').tr, isFirtText: false),
      ],
    );
  }

  Widget _buildContentParaphrase(text, {isFirtText: bool}) {
    return Container(
      margin: EdgeInsets.only(left: 12.w, top: 17.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Transform.rotate(
              angle: pi / 4,
              child: Icon(
                Icons.crop_square_rounded,
                color: Colors.pink,
                size: 14.sp,
              ),
            ),
            SizedBox(width: 6.r),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: isFirtText ? FontWeight.w800 : FontWeight.w400,
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
