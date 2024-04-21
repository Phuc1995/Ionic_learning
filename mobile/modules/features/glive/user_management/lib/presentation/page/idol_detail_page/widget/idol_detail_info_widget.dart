import 'package:common_module/common_module.dart';
import 'package:common_module/presentation/widget/image/avatar_cached_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/follow_controller.dart';

import '../../../../constants/assets.dart';

class IdolDetailInfoWidget extends StatelessWidget {
  const IdolDetailInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FollowController _followController = Get.put(FollowController());
    String _storageUrl = Modular.get<SharedPreferenceHelper>().getStorageUrl();
    return Padding(
      padding: EdgeInsets.only(left: 17.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconItem(_storageUrl, _followController),
          SizedBox(height: 30.h,),
          _buildCount(_followController),
          SizedBox(height: 30.h,),
          _buildInfo(context, _followController),
        ],
      ),
    );
  }
  
  Widget _buildIconItem(String storageUrl, FollowController followController){
    return Container(
      height: 25.h,
      child: IntrinsicHeight(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: Container(
                  color: AppColors.mahogany2,
                  child: Obx(() => Icon(
                    followController.idolDetail.value.gender == 0 ? Icons.female : Icons.male,
                    color: Colors.white,
                    size: 20.sp,
                  )),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              ClipOval(
                child: Container(
                  width: 22.w,
                  child: Obx(() => Center(
                      child: AvatarCachedNetwork(
                        defaultAvatar: Assets.defaultRoomAvatar,
                        fileUrl:  followController.idolDetail.value.level!.medal,
                        storageUrl: storageUrl,
                      )
                  )),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Obx(() => Visibility(
                visible: followController.idolDetail.value.skills!.isNotEmpty,
                child: Row(children: [
                  for(var i in followController.idolDetail.value.skills!) Container(
                    margin: EdgeInsets.only(right: 10.w),
                    height: 22.h,
                    decoration: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.all(Radius.circular(20.r))
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 13.w,
                        ),
                        Container(
                            width: 22.w,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 2.h),
                              child: ImageCachedNetwork(
                                defaultAvatar: Assets.defaultRoomAvatar,
                                fileUrl: i.imageUrl,
                                storageUrl: storageUrl,
                                boxFit: BoxFit.fill,
                              ),
                            )),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(i.name, style: TextUtils.textStyle(FontWeight.w500, 13.sp, color: Colors.white),),
                        SizedBox(
                          width: 13.w,
                        ),
                      ],
                    ),
                  )
                ],),
              ))
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCount(FollowController followController){
    return Row(
      children: [
        Obx(() => _buildCountItem(followController.idolDetail.value.level!.name)),
        SizedBox(width: 10.w,),
        _buildTitleItem("follow_idol_level".tr),
        SizedBox(width: 30.w,),
        Obx(() => _buildCountItem(followController.idolDetail.value.follows!.length.toString())),
        SizedBox(width: 10.w,),
        _buildTitleItem("follow_idol_fan".tr),
      ],
    );
  }

  Widget _buildCountItem(String? str){
    return Text(str??"", style: TextUtils.textStyle(FontWeight.w600, 16.sp, color: AppColors.grayCustom1),);
  }

  Widget _buildTitleItem(String str){
    return Text(str, style: TextUtils.textStyle(FontWeight.w400, 13.sp, color: AppColors.suvaGrey),);
  }

  Widget _buildInfo(BuildContext context, FollowController followController){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => _buildItemInfo(context, "follow_idol_nickname".tr, followController.idolDetail.value.gId??"", isHasCopy: true)),
        SizedBox(height: 15.h,),
        Obx(() => _buildItemInfo(context, "follow_idol_city".tr, followController.idolDetail.value.country??"")),
        SizedBox(height: 15.h,),
        Obx(() => Container(
            child: _buildItemInfo(context, "follow_idol_intro".tr, followController.idolDetail.value.intro??""))),
      ],
    );
  }

  Widget _buildItemInfo(BuildContext context, String title, String content,  {bool isHasCopy = false}){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextUtils.textStyle(FontWeight.w500, 13.sp, color: AppColors.suvaGrey), textAlign: TextAlign.start,),
        Flexible (child: Text(content, style: TextUtils.textStyle(FontWeight.w500, 13.sp, color: AppColors.suvaGrey),)),
        SizedBox(width: 10.w,),
        isHasCopy ? InkWell(
          onTap: (){
            Clipboard.setData(ClipboardData(text: content)).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'home_copied'.tr,
                    style: TextUtils.textStyle(FontWeight.w500, 19.sp,
                        color: Colors.white),
                  )));
            });
          },
          child: Container(
            height: 15.h,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
                color: AppColors.wildWatermelon,
                borderRadius: BorderRadius.all(Radius.circular(20.r))
            ),
            child: Center(child: Text(
                    "follow_idol_copy".tr,
                    style: TextUtils.textStyle(
                      FontWeight.w400,
                      10.sp,
                      color: Colors.white,
                    ),
                  )),
          ),
        ) : Container()
      ],
    );
  }
}
