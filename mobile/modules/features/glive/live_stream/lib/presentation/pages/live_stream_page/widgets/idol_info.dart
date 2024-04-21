import 'package:common_module/common_module.dart';
import 'package:common_module/presentation/widget/image/avatar_cached_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/follow_count.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/idol_detail_sheet/idol_detail_sheet.dart';
import 'package:marquee/marquee.dart';
import 'package:user_management/constants/assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/controllers.dart';
import 'package:user_management/dto/dto.dart';

class IdolInfo extends StatefulWidget {
  final ViewerLiveRoomDto roomData;
  final String roomId;

  const IdolInfo({
    Key? key,
    required this.roomData,
    required this.roomId,
  }) : super(key: key);

  @override
  State<IdolInfo> createState() => _IdolInfoState();
}

class _IdolInfoState extends State<IdolInfo> {
  @override
  Widget build(BuildContext context) {
    String storageUrl = Modular.get<SharedPreferenceHelper>().storageServer + '/' + Modular.get<SharedPreferenceHelper>().bucketName + '/';
    LiveController _liveController = Get.put(LiveController());
    FollowController _followController = Get.put(FollowController());
    final Size size = TextUtils.getSizeText(context, _getNicknameIdol(), TextUtils.textStyle(FontWeight.w400, 12.sp, color: Colors.white,));

    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Obx(() => Container(
            height: 60.h,
            width: !_followController.isFollowing.value ? 240.w : 170.w,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildBorder(),
                Padding(
                  padding: EdgeInsets.only(left: 5.w),
                  child: _buildRoomName(size),
                ),
                Obx(() => Visibility(
                    visible: !_followController.isFollowing.value,
                    child: _buildFollow(_liveController))),
                Obx(() =>  Container(
                    margin: EdgeInsets.only(right: _followController.isFollowing.value ? 110.w : 180.w, bottom: 2.h),
                    child: _buildArmorial(_liveController.armorial, storageUrl, _liveController)),)
              ],
            ),
          )),

    ]);
  }

  Widget _buildBorder(){
    return Container(
      margin: EdgeInsets.fromLTRB(11.w, 8.h, 10.w, 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(ScreenUtil().radius(25.r)),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.black12.withOpacity(0.2),
          borderRadius: BorderRadius.all(
            Radius.circular(25.r),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomName(Size size){
    return Container(
      height: 42.h,
      margin: EdgeInsets.only(left: 43.w, top: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            child: Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                ),
                width: 90.w,
                height: 15.h,
                child: size.width.w < 60.w ?
                Padding(
                  padding: EdgeInsets.only(left: 7.w),
                  child: Text(_getNicknameIdol(), style: TextUtils.textStyle(FontWeight.w400, 12.sp, color: Colors.white,)),
                ) :
                Marquee(
                  text: _getNicknameIdol(),
                  blankSpace: 90.w,
                  style: TextUtils.textStyle(FontWeight.w400, 12.sp, color: Colors.white),
                  startAfter: Duration(seconds: 1),
                  velocity: 15.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: FollowCount(
              roomId: widget.roomId,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAvatar(String storageUrl){
    return Container(
        height: 40.h,
        width: 40.w,
        child: AvatarCachedNetwork(
          storageUrl: storageUrl,
          fileUrl: widget.roomData.imageUrl??'',
          defaultAvatar: Assets.defaultRoomAvatar,
        ),
    );
  }

  Widget _buildFollow(LiveController liveController){
    return InkWell(
      onTap: (){
          liveController.followIdol(widget.roomId);
      },
      child: Container(
        margin: EdgeInsets.only(left: 155.w, top: 13.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30.r)),
        ),
        width: 70.w,
        height: 30.h,
        child: Center(
          child: Text("follow_content".tr, style: TextUtils.textStyle(FontWeight.w600, 12.sp, color: AppColors.wildWatermelon3),),
        ),
      ),
    );
  }

  Widget _buildArmorial(RxString armorial, String storageUrl, LiveController _liveController){
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Center(
            child: _buildAvatar(storageUrl)),
        StreamBuilder(
          stream: FirebaseStorage.getArmorial(widget.roomId),
          builder: (context, AsyncSnapshot snapshot){
            if (snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value != null) {
              armorial.value = snapshot.data.snapshot.value;
            }
            return Obx(() => InkWell(
              onTap: (){
                _liveController.isShownGiftBox.value = true;
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.black12.withOpacity(0.0),
                  builder: (BuildContext context) {
                    return IdolDetailSheet(roomId: widget.roomId,);
                  },
                ).whenComplete(() {
                  _liveController.isShownGiftBox.value = false;
                });
              },
              child:  armorial.value.isNotEmpty ?
              Center(
                child: Container(
                  child: ImageCachedNetwork(
                    fileUrl: armorial.value,
                    storageUrl: storageUrl,
                    defaultAvatar: Assets.defaultRoomAvatar,
                  ) ,
                ),
              )
                  : Container(),
            ));
          },
        ),
      ],
    );
  }

  String _getNicknameIdol() {
    return widget.roomData.gId!;
  }
}
