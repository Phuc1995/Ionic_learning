import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/assets.dart';
import 'package:common_module/presentation/widget/icon/app_icon_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoreInfoField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIconWidget(
            image: Assets.termIcon,
            size: 15,
            height: 20.h,
          ),
          SizedBox(width: 10),
          Text(
            'account_verify_checkbox_text'.tr,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
