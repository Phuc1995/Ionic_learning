import 'package:common_module/common_module.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/controllers/notification_controller.dart';
class NotifyButtonWidget extends StatefulWidget {
  NotifyButtonWidget({Key? key}) : super(key: key);

  @override
  _NotifyButtonWidgetState createState() => _NotifyButtonWidgetState();
}

class _NotifyButtonWidgetState extends State<NotifyButtonWidget> {
  NotificationController _notificationController = Get.put(NotificationController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _notificationController.countUnreadNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15.w),
      child: Stack(
        children: [
          Center(
            child: IconButton(
              onPressed: () =>  Modular.to.pushNamed(ViewerRoutes.notification_page),
              icon: Icon(
                Icons.notifications_none,
                color: AppColors.whiteSmoke7,
                size: 26.sp,
              )
            ),
          ) ,
          Obx(() => _notificationController.unreadNotification.value > 0 ? Center(
            child: Padding(
              padding: EdgeInsets.only(left: 29.w, bottom: 20.h),
              child: CircleAvatar(
                radius: 5.r,
                backgroundColor: AppColors.pink1,
              ),
            ),
          ) : Container(),)
        ],
      )
    );
  }
}