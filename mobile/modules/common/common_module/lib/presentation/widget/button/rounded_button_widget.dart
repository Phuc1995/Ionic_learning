import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final Color? iconColor;
  final IconData? icon;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? margin;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final double? textSize;
  final Border? border;
  final FontWeight? fontWeight;
  final double radius;

  const RoundedButtonWidget({
    Key? key,
    required this.buttonText,
    required this.buttonColor,
    required this.onPressed,
    required this.textColor,
    this.iconColor,
    this.icon,
    this.margin,
    this.padding,
    this.width,
    this.height = 48,
    this.textSize = 13,
    this.border,
    this.fontWeight,
    this.radius = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: buttonColor,
          border: border,
          borderRadius: BorderRadius.all(Radius.circular(radius.r))),
      child: TextButton(
        onPressed: onPressed,
        child: _buildChild(context),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    return icon != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Icon(
                    icon,
                    color: iconColor ?? textColor,
                    size: 16.sp,
                  ),
                ),
              ),
              Center(
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    buttonText,
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: textColor, fontSize: textSize, fontWeight: fontWeight),
                  ),
                ),
              )
            ],
          )
        : Container(
            child: Center(
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                    buttonText,
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: textColor, fontSize: textSize, fontWeight: fontWeight),
                  ),
              ),
            ),
        );
  }
}
