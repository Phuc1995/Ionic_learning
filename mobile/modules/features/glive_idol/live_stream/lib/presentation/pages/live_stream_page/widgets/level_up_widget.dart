import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_stream/constants/assets.dart';
import 'package:get/get.dart';
import 'package:live_stream/controllers/live_stream_controller.dart';

class LevelUpWidget extends StatelessWidget {
  const LevelUpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final liveController = Get.put(LiveStreamController());
    return Center(
      child: Container(
        width: 280.w,
        height: 315.h,
        decoration: BoxDecoration(
            gradient: AppColors.pinkGradientButton,
            borderRadius: BorderRadius.all(Radius.circular(20.r))),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage(Assets.level_up_roll),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  height: 52.h,
                  margin: EdgeInsets.only(top: 30.h),
                  child:
                      Text("${liveController.levelUpValue.value}",
                        textAlign: TextAlign.center,
                        style: TextUtils.textStyle(FontWeight.w500, 18.sp,
                            color: Colors.white),
                      ),
                ),
              ),
              SizedBox(
                height: 10.h,
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
                  width: 94.w,
                  height: 94.h,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(10.r)),
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage(Assets.level_up_light),
                      fit: BoxFit.cover,
                    ),
                    color: ConvertCommon().hexToColor("#CD4A6D")
                  ),
                  child: Obx(() =>
                      Padding(padding: EdgeInsets.fromLTRB(5.w, 10.h, 5.w, 10.h),
                          child: Image.network(liveController.giftReward.value)),),

                ),
              ),
              SizedBox(
                height: 28.h,
              ),
              Center(
                child: RoundedButtonWidget(
                  height: 40.h,
                  buttonText: 'level_up_notification_gift_button'.tr,
                  buttonColor: AppColors.yellow2,
                  textColor: Colors.white,
                  textSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  margin: EdgeInsets.symmetric(horizontal: 40.w),
                  onPressed: () {
                    liveController.isLevelUp.value = false;
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
