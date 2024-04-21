import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:live_stream/controllers/live_stream_controller.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/follow_count.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/view_count.dart';
import 'package:marquee/marquee.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class IdolInfo extends StatelessWidget {
  final String avatar;
  final ProfileResponse profile;
  final String storageUrl;
  final SharedPreferenceHelper sharedPrefsHelper;

  const IdolInfo({
    Key? key,
    required this.avatar,
    required this.profile,
    required this.storageUrl,
    required this.sharedPrefsHelper,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = TextUtils.getSizeText(context, _getNickname(), TextUtils.textStyle(FontWeight.w400, 12.sp, color: Colors.white,));
    final LiveStreamController liveController = Get.put(LiveStreamController());
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
      Container(
        height: 60.h,
        width: 170.w,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 42.h,
              margin: EdgeInsets.fromLTRB(11.w, 8.h, 10.w, 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(ScreenUtil().radius(25.r)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.black12.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.r),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 47.w, top: 0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 100.w,
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.w),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          width: 90.w,
                          height: 15.h,
                          child:  size.width.w < 60.w ?
                          Padding(
                            padding: EdgeInsets.only(left: 7.w),
                            child: Text(_getNickname(), style: TextUtils.textStyle(FontWeight.w400, 12.sp, color: Colors.white,)),
                          ) :
                          Marquee(
                            text: _getNickname(),
                            blankSpace: 90.w,
                            style: TextUtils.textStyle(FontWeight.w400, 12.sp, color: Colors.white),
                            startAfter: Duration(seconds: 1),
                            velocity: 15.0,
                          ),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: FollowCount(
                      roomId: profile.uuid,
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 8.5.w, top: 8.5.h),
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                  image: avatar.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(storageUrl + avatar),
                          fit: BoxFit.fitWidth)
                      : DecorationImage(
                          image: AssetImage(Assets.defaultRoomAvatar), fit: BoxFit.fitWidth),
                  shape: BoxShape.circle,
                  color: Colors.white),
            ),
            Obx(()=>Container(
              height: 57.6.h,
              width: 57.6.w,
              margin: EdgeInsets.only(right: 20.w),
              child: Image.network(liveController.giftReward.isEmpty ? sharedPrefsHelper.armorial! : liveController.giftReward.value),
            )),
          ],
        ),
      ),
      // SizedBox(
      //   width: 8,
      // ),
    ]);
  }

  String _getNickname() {
    return this.profile.gId!;
  }
}
