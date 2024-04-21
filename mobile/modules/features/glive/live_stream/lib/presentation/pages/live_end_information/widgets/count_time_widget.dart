import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';
import 'package:live_stream/presentation/pages/live_channel_idol/live_channel_idol.dart';

class CountTimeWidget extends StatelessWidget {
  const CountTimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var endTime = (DateTime.now().millisecondsSinceEpoch + 1000 * 5);
    LiveController controller = Get.put(LiveController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 54.w,
          height: 1.h,
          color: AppColors.whiteSmoke10,
        ),
        SizedBox(
          width: 15.w,
        ),
        Text("live_end_count_time_mesage".tr,
        style: TextUtils.textStyle(FontWeight.w600, 15.sp, color: Colors.white), textAlign: TextAlign.center),
        // CountdownTimer(
        //   endTime: endTime,
        //   widgetBuilder: (_, time) {
        //     if (time == null) {
        //       return
        //     return Text("live_end_count_time_mesage".tr + " " + '${time.sec}s',
        //         style: TextUtils.textStyle(FontWeight.w600, 15.sp, color: Colors.white), textAlign: TextAlign.center);
        //   },
        // ),
        SizedBox(
          width: 15.w,
        ),
        Container(
          width: 54.w,
          height: 1.h,
          color: AppColors.whiteSmoke10,
        )
      ],
    );
  }
}

