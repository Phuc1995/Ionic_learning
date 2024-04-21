import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GliveInfoWidget extends StatelessWidget {
  final String nickName;
  final String gliveId;
  final num? viewCount;
  final num? fan;
  final num? ruby;
  final num? liveTime;
  final double bottom;

  const GliveInfoWidget({
    Key? key,
    required this.fan,
    required this.ruby,
    required this.viewCount,
    required this.liveTime,
    required this.nickName,
    required this.gliveId,
    this.bottom = 15,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 134.h,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: iconContent(
                      CustomIcons.block,
                      'live_time'.tr,
                      ConvertCommon().formatSecondDuration(int.parse(liveTime.toString())),
                      Colors.white)),
              Expanded(
                child: iconContent(
                    CustomIcons.block, 'live_ruby'.tr, ruby.toString(), AppColors.pink1, true),
              )
            ],
          ),
        ),
        Container(
          height: 134.h,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: iconContent(CustomIcons.person_group, 'live_view_count'.tr,
                    viewCount.toString(), Colors.white),
              ),
              Expanded(
                child: iconContent(
                    CustomIcons.person_head, 'live_fan'.tr, fan.toString(), Colors.white),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget iconContent(IconData icon, String title, String amount, Color color,
      [bool isRuby = false]) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        !isRuby
            ? Icon(
                icon,
                color: Colors.white70,
                size: 28.sp,
              )
            : Image.asset(
                Assets.diamondIcon,
                width: 18.w,
              ),
        SizedBox(
          height: 5,
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white70,
            fontSize: 13.sp,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color,
            fontSize: 24.sp,
          ),
        )
      ],
    );
  }
}
