import 'package:common_module/common_module.dart';
import 'package:common_module/presentation/widget/image/avatar_cached_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/constants/assets.dart';
import 'package:get/get.dart';
import 'package:user_management/dto/idol_detail_dto.dart';
import 'package:user_management/controllers/follow_controller.dart';

class ShowUnfollowSheet{

  void showUnfollowSheet({required BuildContext context, required String storageUrl, required IdolDetailDto idolDetail, required String uuidIdol, required FollowController followController}){
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 320.h,
          width: 100.w,
          color: Colors.black.withOpacity(0.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.r))
            ),
            margin: EdgeInsets.only(left: 50.w, right: 50.w, bottom: 50.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10.h,),
                Container(
                    width: 90.w,
                    height: 90.h,
                    child: AvatarCachedNetwork(storageUrl: storageUrl, fileUrl: idolDetail.imageUrl??"", defaultAvatar: Assets.defaultRoomAvatar,)
                ),
                SizedBox(height: 15.h,),
                Text("follow_idol_unfollow_text".tr, style: TextUtils.textStyle(FontWeight.w400, 13.sp, color: AppColors.grayCustom),),
                SizedBox(height: 5.h,),
                Container(
                    height: 20.h,
                    child: Text(idolDetail.gId??"", style: TextUtils.textStyle(FontWeight.w500, 14.sp, color: AppColors.wildWatermelon3),)),
                SizedBox(height: 10.h,),
                RoundedButtonWidget(
                  height: 40.h,
                  width: 240.w,
                  buttonText: "follow_idol_unfollow_button".tr,
                  buttonColor: Colors.white,
                  onPressed: (){
                    followController.unfollowIdol(uuidIdol);
                    Navigator.pop(context);
                  },
                  border: Border.all(color: AppColors.wildWatermelon3, width: 1.w),
                  radius: 30,
                  textColor: AppColors.wildWatermelon3,
                ),
                SizedBox(height: 10.h,),
                RoundedButtonWidget(
                  height: 40.h,
                  width: 240.w,
                  buttonText: "follow_idol_keep_follow_button".tr,
                  buttonColor: Colors.white,
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  border: Border.all(color: AppColors.whiteSmoke4, width: 1.w),
                  radius: 30,
                  textColor: AppColors.whiteSmoke4,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}