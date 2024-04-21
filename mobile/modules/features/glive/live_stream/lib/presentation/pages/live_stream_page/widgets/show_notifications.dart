import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';
import 'package:user_management/constants/assets.dart';
import 'dart:convert';

class ShowNotificationWidget extends StatefulWidget {
  final LiveController liveController;

  const ShowNotificationWidget({
    Key? key,
    required this.liveController,
  }) : super(key: key);

  @override
  _ShowNotificationWidgetState createState() => _ShowNotificationWidgetState();
}

class _ShowNotificationWidgetState extends State<ShowNotificationWidget> {
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        widget.liveController.isLiveTime.value = false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0.h, right: 16.w, left: 16.w),
      child: Row(
        children: [
          Container(
            height: 60.h,
            width: 300.w,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.pink1, width: 1.5),
                    borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().radius(5.r)),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        gradient: AppColors.pinkGradientNotificationBox,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(9.w, 7.h, 0.w, 7.h),
                  child: Image(
                    image: AssetImage(Assets.coinIcon),
                    width: 46.w,
                    height: 46.h,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 65.w, top: 13.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(left: 0.w),
                          child: Text(widget.liveController.titleExp.value ,
                            style: TextUtils.textStyle(FontWeight.w500, 15.sp,
                                color: AppColors.yellow1),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(left: 0.w, bottom: 2.h),
                          child: Text(widget.liveController.contentExp.value ,
                            style: TextUtils.textStyle(FontWeight.w300, 10.sp,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    if (int.parse(parts[0]) > 0) {
      if (int.parse(parts[1]) > 0) {
        return parts[0] + ' ' + 'live_give_hour'.tr + ' ' + parts[1] + ' ' + 'live_give_second'.tr;
      } else {
        return parts[0] + ' ' + 'live_give_hour'.tr;
      }
    } else {
      return parts[1] + ' ' + 'live_give_second'.tr;
    }
  }
}
