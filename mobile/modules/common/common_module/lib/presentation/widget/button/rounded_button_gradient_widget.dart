import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedButtonGradientWidget extends StatelessWidget {
  final String buttonText;
  final Gradient? buttonColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? margin;
  final double textSize;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final bool isEnabled;
  final Border? border;
  final String? icon;
  final String? iconAsset;
  final Icon? icons;

  const RoundedButtonGradientWidget({
    Key? key,
    required this.buttonText,
    required this.buttonColor,
    required this.onPressed,
    this.textColor = Colors.white,
    this.margin,
    this.width,
    required this.height ,
    required this.textSize ,
    this.padding,
    this.isEnabled = true,
    this.border,
    this.icon,
    this.iconAsset,
    this.icons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
          gradient: isEnabled ? buttonColor: null,
          color: !isEnabled ? AppColors.whiteSmoke : null,
          border: border,
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(context) {
    if (icon != null) { // Check has icon
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Image.network(
              icon!,
              width: 30.w,
              height: 30.h,
            ),
          ),
          TextButton(
            onPressed: isEnabled ? onPressed : null,
            style: TextButton.styleFrom(padding: padding),
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                buttonText,
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: textColor, fontSize: textSize),
              ),
            ),
          )
        ],
      );
    }
    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(padding: padding),
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Row(
          children: [
            iconAsset != null ? Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Image.asset(iconAsset!),
            ) : Container(),
            icons != null ? Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: icons,
            ) : Container(),
            Text(
              buttonText,
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: textColor, fontSize: textSize),
            ),
          ],
        ),
      ),
    );
  }
}
