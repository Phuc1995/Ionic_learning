import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconButtonWidget extends StatelessWidget {
  final GestureTapCallback onPressed;
  final Color? iconColor;
  final IconData? icon;
  final double? iconSize;
  final double? width;
  final double? height;
  final Gradient buttonColor;
  final bool isNumber;
  final int number;

  const IconButtonWidget(
      {Key? key,
      required this.onPressed,
      required this.buttonColor,
      this.icon,
      this.isNumber = false,
      this.number = 0,
      this.iconColor,
      this.iconSize = 14,
      this.width = 26,
      this.height = 26})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: buttonColor,
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: !isNumber
            ? Icon(
                icon,
                color: iconColor ?? Colors.white,
                size: iconSize,
              )
            : Center(
                child: Text(number.toString(),
                    style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14.sp)),
              ),
      ),
    );
  }
}
