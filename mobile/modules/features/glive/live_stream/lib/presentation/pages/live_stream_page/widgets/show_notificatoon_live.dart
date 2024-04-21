import 'dart:async';

import 'package:common_module/common_module.dart';
import 'package:common_module/presentation/widget/image/avatar_cached_network.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_stream/constants/assets.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';

class ShowNotificationLive extends StatefulWidget {
  final StreamController<bool> stream;
  final FijkPlayer fijkPlayer;
  const ShowNotificationLive({Key? key, required this.stream, required this.fijkPlayer}) : super(key: key);

  @override
  State<ShowNotificationLive> createState() => _ShowNotificationLiveState();
}

class _ShowNotificationLiveState extends State<ShowNotificationLive> {
  String _storageUrl = Modular.get<SharedPreferenceHelper>().storageServer + '/' + Modular.get<SharedPreferenceHelper>().bucketName + '/';
  LiveController _liveController = Get.put(LiveController());
  String _userUuid = Modular.get<SharedPreferenceHelper>().getUserUuid.toString();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell (
      onTap: () async{
        int roomIndex = _liveController.listRoom.indexWhere((ele) => ele.id == _liveController.notificationInAppEntity.value.uuidIdol);
        if(roomIndex >= 0){
          _liveController.jumpToPage(roomIndex, _userUuid);
        }
        widget.stream.add(false);
        await widget.fijkPlayer.reset();
        await widget.fijkPlayer.setDataSource(_liveController.currentRoom.value.flv ?? _liveController.currentRoom.value.hls.toString(), autoPlay: true);
      },
      child: Container(
        width: 260.w,
        height: 62.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.pink1, width: 1.5),
          borderRadius: BorderRadius.horizontal(left: Radius.circular(5.r)),
          gradient: AppColors.pinkNotifyLiveBox,
          ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              margin: EdgeInsets.only(left: 5.w),
              padding: EdgeInsets.all(3.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50.r)),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: AvatarCachedNetwork(storageUrl: _storageUrl, defaultAvatar: Assets.defaultRoomAvatar, fileUrl: _liveController.notificationInAppEntity.value.urlImage,),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        constraints: BoxConstraints(maxWidth: 110.w),
                        child: Text(
                          _liveController.notificationInAppEntity.value.nameIdol,
                          style: TextUtils.textStyle(
                            FontWeight.w600,
                            14.sp,
                            color: AppColors.yellow1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        )),
                    Text("follow_idol_in_app_online".tr,
                      style: TextUtils.textStyle(
                        FontWeight.w600,
                        14.sp,
                        color: AppColors.yellow1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
                SizedBox(height: 5.h,),
                Text("follow_idol_in_app_online_press".tr, style: TextUtils.textStyle(FontWeight.w400, 14.sp, color: AppColors.whiteSmoke11),)
              ],
            )
          ],
        ),
      ),
    );
  }
}



