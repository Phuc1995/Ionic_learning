import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_stream/presentation/pages/live_channel_idol/live_channel_idol.dart';

class BuildItemLiveWidget{
  LiveController controller = Get.put(LiveController());
  Widget build(int index, bool isEndlive, BuildContext context){
    return InkWell(
      onTap: () {
        if(isEndlive){
          Modular.to.pop();
        }
        controller.currentRoomIndex.value = index;
        controller.currentRoom.value = controller.listRoom[index];
        controller.currentRoom.refresh();
        Modular.to.pushNamed(ViewerRoutes.live_channel_idol, arguments: {
          'roomData': controller.currentRoom.value,
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: controller.listRoom[index].tag != "",
            child: Container(
                margin: EdgeInsets.only(top: 7.h, left: 10.w),
                height: 15.h,
                width: 50.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: LinearGradient(
                        colors: [Color(0xFFE92B7A), Color(0xFFFF9D88)],
                        begin: Alignment(-0.1, -1),
                        end: Alignment(0.03, 1.5))),
                child: Center(
                  child: Text(
                    controller.listRoom[index].tag.toString(),
                    style: TextUtils.textStyle(FontWeight.w700, 10.sp, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
          Container(
              margin: EdgeInsets.only(bottom: 7.h, left: 10.w, right: 10.w),
              height: 15.h,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.volume_up_outlined,
                        color: Colors.white,
                        size: 10.sp,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Container(
                          width: 100.w,
                          child: Text(
                            controller.listRoom[index].room.toString(),
                            style: TextUtils.textStyle(FontWeight.w700, 10.sp, color: Colors.white),
                          ),
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye_rounded,
                        color: Colors.white,
                        size: 10.sp,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        controller.listRoom[index].viewCount.toString(),
                        style: TextUtils.textStyle(FontWeight.w700, 10.sp, color: Colors.white),
                      )
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }
}
