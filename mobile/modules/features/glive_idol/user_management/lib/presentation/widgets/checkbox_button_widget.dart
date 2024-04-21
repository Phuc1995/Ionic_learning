import 'package:flutter/material.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/domain/entity/response/category_response.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckboxButton extends StatelessWidget {
  final CategoryResponse item;
  final bool selected;
  final VoidCallback onPressed;
  final String storageUrl;

  CheckboxButton({
    Key? key,
    required this.item,
    this.selected = false,
    required this.onPressed,
    required this.storageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return RoundedButtonGradientWidget(
      textSize: 16.sp,
      icon: storageUrl + item.icon.toString(),
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
