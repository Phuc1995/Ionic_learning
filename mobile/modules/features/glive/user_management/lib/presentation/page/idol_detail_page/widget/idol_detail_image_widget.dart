import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/controllers/follow_controller.dart';
import 'package:get/get.dart';

class IdolDetailImageWidget extends StatelessWidget {
  const IdolDetailImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FollowController _followController = Get.put(FollowController());
    String storageUrl = Modular.get<SharedPreferenceHelper>().getStorageUrl();
    return Container(
        height: 350.h,
        child: Stack(
          children: [
            Stack(children: [
              Obx(() => _buildImage(storageUrl, _followController.idolDetail.value.imageUrl??"")),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      height: 145.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              Modular.to.pop();
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                          Text("Báo cáo", style: TextUtils.textStyle(FontWeight.w400, 14.sp, color: Colors.white), ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],),
            Padding(
              padding: EdgeInsets.only(bottom: 40.h),
              child: Align(
                alignment: Alignment.bottomRight,
                child: _buildStatus(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.w,bottom: 30.h),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: 220.w,
                  height: 40.h,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Obx(() => Text(
                      _followController.idolDetail.value.gId??"",
                      style: TextUtils.textStyle(FontWeight.w500, 24.sp, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r), topRight: Radius.circular(15.r),),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildImage(String storageUrl, String urlAvatar) {
    return urlAvatar == ''
        ? Center(
      child: Container(
          decoration: BoxDecoration(
              gradient: AppColors.DarkTopGradientBackground,
              border: Border(
                bottom: BorderSide(width: 2, color: Colors.white),
                top: BorderSide(width: 2, color: Color(0xFFababab)),
              )),
          width: double.infinity,
          child: Container(
            child: Center(
                child: Image.asset(
                  Assets.defaultRoomAvatar,
                )),
          )),
    )
        : Container(
      decoration: BoxDecoration(
          gradient: AppColors.DarkTopGradientBackground,
          border: Border(
            bottom: BorderSide(width: 2, color: Colors.white),
            top: BorderSide(width: 2, color: Color(0xFFababab)),
          )),
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0.r),
        child:
        Image.network(
          storageUrl + urlAvatar,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _buildStatus(){
    return Container(
      height: 32.h,
      width: 130.w,
      decoration: BoxDecoration(
        color: AppColors.mountainMeadow2,
        borderRadius: BorderRadius.horizontal(left: Radius.circular(30.r)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(Assets.certificate_icon),
          Text("Đã xác minh", style: TextUtils.textStyle(FontWeight.w500, 12.sp, color: Colors.white),)
        ],
      ),
    );
  }
}
