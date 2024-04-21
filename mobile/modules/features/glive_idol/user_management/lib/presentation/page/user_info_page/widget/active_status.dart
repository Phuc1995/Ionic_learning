import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ActiveStatus extends StatelessWidget {

  String? status;
  String? note;
  bool? isInfo;

  ActiveStatus({Key? key, this.status, this.note, this.isInfo = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 'APPROVED':
        return RoundedButtonWidget(
          height: 40.h,
          buttonText: 'home_verified'.tr,
          buttonColor: AppColors.mountainMeadow2,
          textColor: Colors.white,
          textSize: 12.sp,
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          icon: CustomIcons.shield_check,
          onPressed: () {},
        );
      case 'NOT_VERIFY':
      case 'VERIFYING':
        return RoundedButtonWidget(
          border: Border.all(color: AppColors.grey),
          height: 40.h,
          buttonText: 'home_in_progress'.tr,
          buttonColor: Colors.white,
          textColor: AppColors.grey,
          textSize: 12.sp,
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          icon: Icons.watch_later,
          onPressed: () {},
        );
      case 'FAILED':
        return Row(
          mainAxisAlignment: isInfo! ? MainAxisAlignment.end :MainAxisAlignment.center,
          children: <Widget>[
            RoundedButtonWidget(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              height: 40.h,
              buttonText: 'home_rejected'.tr,
              buttonColor: AppColors.mahogany,
              textColor: Colors.white,
              textSize: 12.sp,
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              icon: Icons.cancel,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return new CustomDialogBox(
                        buttonText: 'button_reconfirm'.tr,
                        title: 'information_title_confirm'.tr,
                        subTitle: note ?? '',
                        onPressed: () => Modular.to.pushNamed(IdolRoutes.user_management.accountVerifyStep1Screen),
                        imgIcon: AppIconWidget(
                          image: Assets.closeIcon,
                          size: 155.sp,
                          height: 150.h,
                        )
                      );
                    });
              },
            ),
          ],
        );
      case 'REJECTED':
        return Row(
          mainAxisAlignment: isInfo! ? MainAxisAlignment.end :MainAxisAlignment.center,
          children: <Widget>[
            RoundedButtonWidget(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              height: 40.h,
              buttonText: 'home_rejected'.tr,
              buttonColor: AppColors.mahogany,
              textColor: Colors.white,
              textSize: 12.sp,
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              icon: Icons.cancel,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return new CustomDialogBox(
                        buttonText: 'button_reconfirm'.tr,
                        title: 'information_title_confirm'.tr,
                        subTitle: note ?? '',
                        onPressed: () => Modular.to.pushNamed(IdolRoutes.user_management.accountVerifyStep1Screen),
                        imgIcon: AppIconWidget(
                          image: Assets.closeIcon,
                          size: 155.sp,
                          height: 150.h,
                        )
                      );
                    });
              },
            ),
          ],
        );
      default:
        return Row(
          mainAxisAlignment: isInfo! ? MainAxisAlignment.end :MainAxisAlignment.center,
          children: <Widget>[
            RoundedButtonWidget(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              height: 40.h,
              buttonText: 'home_verify_now'.tr,
              buttonColor: AppColors.gainsboro,
              textColor: Colors.black,
              textSize: 12.sp,
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              onPressed: () {
                Modular.to.pushNamed(IdolRoutes.user_management.accountVerifyStep1Screen);
              },
            ),
          ],
        );
    }
  }
}
