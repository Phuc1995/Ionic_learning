import 'package:common_module/common_module.dart';
import 'package:common_module/presentation/widget/image/avatar_cached_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';
import 'package:live_stream/presentation/pages/live_channel_idol/live_channel_idol.dart';
import 'package:user_management/constants/assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/controllers/follow_controller.dart';
import 'package:get/get.dart';

class IdolStreamingWidget extends StatefulWidget {
  const IdolStreamingWidget({Key? key}) : super(key: key);

  @override
  State<IdolStreamingWidget> createState() => _IdolStreamingWidgetState();
}

class _IdolStreamingWidgetState extends State<IdolStreamingWidget> {
  FollowController _followController = Get.put(FollowController());
  String _storageUrl = Modular.get<SharedPreferenceHelper>().getStorageUrl();
  LiveController _liveController = Get.put(LiveController());
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _followController.initIdolStreaming(_scrollController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _followController.idolStreaming.length > 0 ? Container(
      alignment: Alignment.centerLeft,
      color: AppColors.whiteSmoke14,
      height: 110.h,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(top: 17.h),
        child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: _followController.idolStreaming.length,
          itemBuilder: (BuildContext context, int index) {
            return _createListItem(context, index, _liveController);
          },),
      ),
    ) : _buildNoLive()) ;
  }

  Widget _createListItem(BuildContext context, int index, LiveController liveController){
    return InkWell(
      onTap: (){
        int roomIndex = liveController.listRoom.indexWhere((ele) => ele.id == _followController.idolStreaming[index].uuid);
        if(roomIndex >= 0){
          liveController.currentRoom.value = liveController.listRoom[roomIndex];
          liveController.currentRoom.refresh();
          Modular.to.pushNamed(ViewerRoutes.live_channel_idol, arguments: {'roomData': liveController.currentRoom.value});
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.pink,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.r)),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: AvatarCachedNetwork(storageUrl: _storageUrl, defaultAvatar: Assets.defaultRoomAvatar, fileUrl: _followController.idolStreaming[index].imageUrl??'',),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Align(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.pinkGradientButton,
                      borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(40.r))),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
                      child: Center(child: Text("follow_idol_live".tr, style: TextUtils.textStyle(FontWeight.w500, 10.sp, color: Colors.white), textAlign: TextAlign.center,) ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 75.w, maxHeight: 22.h),
            margin: EdgeInsets.only(left: 5.w),
            alignment: Alignment.center,
            width: 75.w,
            height: 30.h,
            child: Text(_followController.idolStreaming[index].gId??" ", overflow: TextOverflow.ellipsis,),
          )
        ],
      ),
    );
  }

  Widget _buildNoLive(){
    return Container(
      alignment: Alignment.center,
      color: AppColors.whiteSmoke14,
      height: 110.h,
      child: Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: Column(
          children: [
            Image.asset(Assets.noLiveStreaming, width: 40.w, height: 67.h,),
            Text("follow_idol_no_live".tr, style: TextUtils.textStyle(FontWeight.w500, 14.sp),)
          ],
        ),
      ),
    );
  }
}
