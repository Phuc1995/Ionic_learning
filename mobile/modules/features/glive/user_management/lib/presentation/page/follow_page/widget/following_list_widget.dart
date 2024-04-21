import 'dart:ui';

import 'package:common_module/common_module.dart';
import 'package:common_module/presentation/widget/image/avatar_cached_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';
import 'package:user_management/constants/assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/dto/idol_detail_dto.dart';
import 'package:user_management/controllers/follow_controller.dart';
import 'package:get/get.dart';
import 'package:user_management/presentation/page/follow_page/widget/show_unfollow_sheet.dart';


class FollowingListWidget extends StatefulWidget {
  const FollowingListWidget({Key? key}) : super(key: key);

  @override
  State<FollowingListWidget> createState() => _FollowingListWidgetState();
}

class _FollowingListWidgetState extends State<FollowingListWidget> {
  ScrollController _scrollController = ScrollController();
  FollowController _followController = Get.put(FollowController());
  LiveController _liveController = Get.put(LiveController());
  late final String storageUrl = Modular.get<SharedPreferenceHelper>().getStorageUrl();

  @override
  void initState() {
    _followController.initFollowingList(_scrollController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 5.w, top: 25.h),
            height: 620.h,
            color: Colors.white,
            child: Obx(() =>
                ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  itemCount: _followController.idolList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _createListItem(context, index);
                  },),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createListItem(BuildContext context, int index){
    IdolDetailDto idol = _followController.idolList[index];
    return ListTile(
      leading: InkWell(
          onTap: (){
            _followController.navigateIdolDetail(index, _liveController);
          },
          child: _avatar(idol)),
      title: InkWell(
        onTap: (){
          _followController.navigateIdolDetail(index, _liveController);
        },
        child: Container(
          width: 200.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
            children: [
               Container(
                 width: 140.w,
                child: Text(
                  idol.gId??idol.uuid,
                  overflow: TextOverflow.ellipsis,
                  style: TextUtils.textStyle(
                    FontWeight.w500,
                    15.sp,
                    color: idol.isBanned! ? AppColors.whiteSmoke: AppColors.grayCustom2,
                  ),
                ),
              ),
              idol.isStreaming! ? _idolLive() : Container(
                alignment: Alignment.centerLeft,
                width: 70.w,
                child: Text(
                  'follow_idol_live'.tr,
                  style: TextUtils.textStyle(
                    FontWeight.w400,
                    11.sp,
                    color: AppColors.whiteSmoke,
                  ),
                ),
              ),
            ],),
        ),
      ),
      subtitle: InkWell(
        onTap: (){
          _followController.navigateIdolDetail(index, _liveController);
        },
        child: Container(
          width: 280.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              idol.intro == "" ? Container() : Container(
                width: 140.w,
                child: Text(
                  idol.intro!,
                  overflow: TextOverflow.ellipsis,
                  style: TextUtils.textStyle(
                    FontWeight.w400,
                    12.sp,
                    color: idol.isBanned! ? AppColors.whiteSmoke: AppColors.grey3,
                  ),
                ),
              ),
              idol.isStreaming! ? Container() :  Container(
                width: 70.w,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(_followController.timeLiveAgo(currentTime: idol.currentTime, latestLiveTime: idol.latestLiveTime), style: TextUtils.textStyle(
                    FontWeight.w400,
                    12.sp,
                    color: AppColors.whiteSmoke,
                  ), textAlign: TextAlign.left),
                ),
              )
            ],
          ),
        ),
      ),
      trailing: InkWell(
        onTap: (){
          if(_followController.idolList[index].isFollowed!){
            ShowUnfollowSheet().showUnfollowSheet(context: context, storageUrl: storageUrl , idolDetail: idol, uuidIdol: idol.uuid, followController: _followController);
          } else {
            _followController.followIdol(idol.uuid);
          }
        },
        child: Container(
          width: 35.w,
          child: Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Obx(() => _followController.idolList[index].isFollowed! ? Icon(Icons.check, color: AppColors.whiteSmoke,) : Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(30.r))),
                  border: Border.all(
                      color: AppColors.pink1
                  ),
              ),
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Icon(Icons.add, color: AppColors.wildWatermelon3, size: 16.sp,)),
            )),
          ),
        ),
      ),
    );
  }


  Widget _avatar(IdolDetailDto idol){
    Widget wg = AvatarCachedNetwork(storageUrl: storageUrl, defaultAvatar: Assets.defaultRoomAvatar, fileUrl:idol.imageUrl??'',);
    wg = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50.r)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: AvatarCachedNetwork(isBlur: idol.isBanned!, storageUrl: storageUrl, defaultAvatar: Assets.defaultRoomAvatar, fileUrl:idol.imageUrl??'',),
            )),
        Positioned(
          bottom: 0,
          child: Align(
            child: Container(
              decoration: BoxDecoration(
                color: idol.isBanned! ? AppColors.turquoise2 : AppColors.turquoise,
                borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(40.r))),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
                child: Center(child: Text("Lv" + idol.level!.name.toString(), style: TextUtils.textStyle(FontWeight.w500, 10.sp, color: Colors.white), textAlign: TextAlign.center,) ),
              ),
            ),
          ),
        ),
      ],
    );
    return wg;
  }


  Widget _idolLive(){
    return Container(
      width: 70.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 10.h,
            width: 10,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage(
                  Assets.animation_live,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 5.w,),
          Text(
            'follow_idol_live'.tr,
            style: TextUtils.textStyle(
              FontWeight.w400,
              11.sp,
              color: AppColors.wildWatermelon3,
            ),
          ),
        ],
      ),
    );
  }
}
