import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/manage_user/show_list_manage.dart';
import 'package:user_management/presentation/page/user_info_page/widget/count_item.dart';

class ShowUserManage extends StatelessWidget {
  final Rx<LiveMessageDto> liveMessage;
  final String storageUrl;

  const ShowUserManage({Key? key, required this.storageUrl, required this.liveMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360.h,
      width: 600.w,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 300.h,
              color: Colors.white,
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      showModalBottomSheet<void>(
                        enableDrag: true,
                        context: context,
                        backgroundColor: Colors.black12.withOpacity(0.0),
                        builder: (BuildContext context) {
                          return ShowListManage(liveMessage: liveMessage, storageUrl: storageUrl,);
                        },
                      );
                    },
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 20.w, top: 10.h),
                          child: Text("live_manage_user".tr,
                            style: TextUtils.textStyle(FontWeight.w500, 13.sp, color: AppColors.grey3),),
                        )),
                  ),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.only(top: 55.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("live_manage_full_name".tr + ": ",
                            textAlign: TextAlign.center,
                            style: TextUtils.textStyle(FontWeight.w500, 17.sp),),
                          Text(liveMessage.value.name,
                            textAlign: TextAlign.center,
                            style: TextUtils.textStyle(FontWeight.w500, 17.sp, color: AppColors.grey),)
                        ],
                      ),
                    ),
                  ),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CountItem(count: 1, text: 'Level', onTap: () {}),
                          // CountItem(count: 0, text: 'home_follows'.tr, onTap: () {}),
                          CountItem(count: 0, text: 'home_fans'.tr, onTap: () {}),
                          // CountItem(count: 0, text: 'Moments', onTap: () {}),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  Divider(thickness: 1.h, color: AppColors.whiteSmoke11,),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("@ người dùng này".tr ,
                            textAlign: TextAlign.center,
                            style: TextUtils.textStyle(FontWeight.w500, 17.sp, color: AppColors.grey),),
                          Container(
                            margin: EdgeInsets.only(left: 25.w, right: 25.w),
                            width: 1.w,
                            height: 30.h,
                            color: AppColors.whiteSmoke11,
                          ),
                          Container(
                            height: 30.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.r),
                                gradient: AppColors.pinkGradientButton
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 15.w),
                                  child: Icon(Icons.add, color: Colors.white, size: 20.sp,),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.w, right: 15.w),
                                  child: Text("home_follows".tr,
                                    style: TextUtils.textStyle(FontWeight.w600, 16.sp, color: Colors.white),),
                                )
                              ],),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child:
            AvataCommon(width: 120.w, height: 120.h, color: Colors.white, avatarUrl: storageUrl + liveMessage.value.imageUrl, shape: BoxShape.circle, padding: 5.r,),
          ),

        ],
      ),
    );
  }
}
