import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_stream/constants/assets.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/manage_user/show_list_manage.dart';
import 'package:user_management/controllers/controllers.dart';
import 'package:user_management/presentation/page/user_info_page/widget/count_item.dart';
import 'package:user_management/presentation/widgets/avatar_widget.dart';

class ShowUserManage extends StatelessWidget {
  final Rx<LiveMessageDto> liveMessage;
  final String storageUrl;

  const ShowUserManage({Key? key, required this.storageUrl, required this.liveMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FollowController _followController = Get.put(FollowController());
    return Container(
      height: 300.h,
      width: 600.w,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 220.h,
              color: Colors.white,
              child: Column(
                children: [
                  // InkWell(
                  //   onTap: (){
                  //     // showModalBottomSheet<void>(
                  //     //   enableDrag: true,
                  //     //   context: context,
                  //     //   backgroundColor: Colors.black12.withOpacity(0.0),
                  //     //   builder: (BuildContext context) {
                  //     //     return ShowListManage(liveMessage: liveMessage, storageUrl: storageUrl,);
                  //     //   },
                  //     // );
                  //   },
                  //   child: Align(
                  //       alignment: Alignment.centerRight,
                  //       child: Padding(
                  //         padding: EdgeInsets.only(right: 20.w, top: 10.h),
                  //         child: Text("home_follows".tr,
                  //           style: TextUtils.textStyle(FontWeight.w500, 13.sp, color: AppColors.grey3),),
                  //       )),
                  // ),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.only(top: 70.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("live_manage_full_name".tr + ": ",
                            textAlign: TextAlign.center,
                            style: TextUtils.textStyle(FontWeight.w500, 17.sp),),
                          Text(liveMessage.value.gId,
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
                          CountItem(count: liveMessage.value.level!, text: 'Level', onTap: () {}),
                          Obx(() => CountItem(count: _followController.countFollowingViewer.value.toString(), text: 'home_follows'.tr, onTap: () {}),
                          )
                          ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: AvatarWidget(
              armorial: liveMessage.value.armorial,
              isAvatarProfile: false,
              height: 140,
              storageUrl: storageUrl,
              radius: 23,
              fileUrl: liveMessage.value.imageUrl,
              onChange: (String val) {
              },
            ),
          ),
        ],
      ),
    );
  }
}
