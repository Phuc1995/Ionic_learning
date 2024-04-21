import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_stream/constants/assets.dart';
import 'package:get/get.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';

class LevelUpWidget extends StatelessWidget {
  final String storageUrl;
  const LevelUpWidget({Key? key, required this.storageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final liveController = Get.put(LiveController());
    return Center(
      child: Container(
        width: 280.w,
        height: 315.h,
        decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage(Assets.congrat_bg),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20.r))),
        child: Column(
          children: [
            Center(
              child: Container(
                height: 52.h,
                width: 180.w,
                margin: EdgeInsets.only(top: 30.h),
                child:
                    Obx(()=> Text(
                      "${liveController.levelUpValue.value}",
                      textAlign: TextAlign.center,
                      style: TextUtils.textStyle(FontWeight.w600, 14.sp,
                          color: Colors.white),
                    )),
              ),
            ),
            Center(
              child: Container(
                child: Text(
                  "level_up_notification_gift".tr,
                  textAlign: TextAlign.center,
                  style: TextUtils.textStyle(FontWeight.w400, 13.sp,
                      color: AppColors.yellow1),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Center(
              child: Container(
                width: 82.w,
                height: 82.h,
                child: Obx(() => ImageCachedNetwork(storageUrl: storageUrl, fileUrl: liveController.giftReward.value, defaultAvatar: Assets.defaultAvatar),),
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            Center(
              child: RoundedButtonWidget(
                height: 39.h,
                buttonText: 'level_up_notification_gift_button'.tr,
                buttonColor: AppColors.yellow2,
                textColor: Colors.white,
                textSize: 14.sp,
                fontWeight: FontWeight.w600,
                margin: EdgeInsets.symmetric(horizontal: 70.w),
                onPressed: () {
                  liveController.isLevelUp.value = false;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
