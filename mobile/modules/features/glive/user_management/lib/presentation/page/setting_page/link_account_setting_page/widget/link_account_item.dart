import 'package:badges/badges.dart';
import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LinkAccountItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final String linkedLabel;
  final bool isLinked;
  final VoidCallback? onPressed;

  const LinkAccountItem({
    Key? key,
    required this.icon,
    required this.label,
    this.linkedLabel = '',
    this.isLinked = false,
    this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onPressed != null) onPressed!();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.only(right: 10.sp),
                  width: 30.sp,
                  height: 30.sp,
                  child: icon,
                ),
                Text(
                  label,
                  style: TextUtils.textStyle(FontWeight.w400, 18.sp,
                      color: AppColors.grayCustom),
                ),
              ],
            ),
            isLinked
                ? Text(
              linkedLabel.isNotEmpty ? linkedLabel : 'link_account_connected'.tr,
              style: TextUtils.textStyle(FontWeight.w400, 16.sp,
                  color: AppColors.grayCustom1),
            )
                : Badge(
              toAnimate: false,
              elevation: 0,
              shape: BadgeShape.square,
              badgeColor: AppColors.pink[400]!,
              borderRadius: BorderRadius.circular(30),
              badgeContent: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3),
                child: Text('link_account_connect'.tr, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
              ),
            )
          ],
        ),
      ),
    );
  }

}