import 'package:flutter/material.dart';
import 'package:common_module/common_module.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TagPill extends StatelessWidget {
  final String tag;
  final VoidCallback onPressed;
  final Color? iconColor;
  final IconData? icon;
  final TextStyle? style;
  final double? iconSize;
  final double? horizontal;
  final double? vertical;
  final Color? colorFill;

  TagPill(
      {Key? key,
      required this.tag,
      required this.onPressed,
      this.icon,
      this.iconColor,
      this.style,
      this.iconSize,
      this.horizontal,
      this.vertical,
      this.colorFill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: this.onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: this.horizontal ?? 26.w,
          vertical: this.vertical ?? 8.h,
        ),
        decoration: BoxDecoration(
          color: this.colorFill ?? AppColors.whiteSmoke5,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                this.tag,
                style: this.style,
              ),
              this.icon != null
                  ? Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Icon(
                  this.icon,
                  color: this.iconColor ?? Colors.white,
                  size: this.iconSize ?? 13.sp,
                ),
              )
                  : Container(),
            ]),
      ),
    );
  }
}
