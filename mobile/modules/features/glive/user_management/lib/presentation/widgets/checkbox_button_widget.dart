import 'package:flutter/material.dart';
import 'package:common_module/common_module.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/dto/category_response_dto.dart';

class CheckboxButton extends StatelessWidget {
  final CategoryResponseDto item;
  final bool selected;
  final VoidCallback onPressed;

  CheckboxButton({
    Key? key,
    required this.item,
    this.selected = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedButtonGradientWidget(
      textSize: 16.sp,
      icon: item.icon,
      height: 40.h,
      margin: EdgeInsets.all(5.w),
      padding: item.icon != null
          ? EdgeInsets.fromLTRB(5.w, 0, 10.w, 0)
          : EdgeInsets.symmetric(horizontal: 25.w),
      buttonText: item.name,
      buttonColor: selected ? AppColors.pinkGradientButton : null,
      textColor: selected ? Colors.white : Colors.black,
      border: Border.all(
        width: 1.0.w,
        color: selected ? Colors.transparent : AppColors.whiteSmoke,
      ),
      onPressed: onPressed,
    );
  }
}
