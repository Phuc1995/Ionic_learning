import 'package:common_module/common_module.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/domain/usecase/notification/count_unread_notification.dart';
import 'package:user_management/presentation/controller/notification/notification_controller.dart';
class NotifyButtonWidget extends StatefulWidget {
  NotifyButtonWidget({Key? key}) : super(key: key);

  @override
  _NotifyButtonWidgetState createState() => _NotifyButtonWidgetState();
}

class _NotifyButtonWidgetState extends State<NotifyButtonWidget> {
  NotificationController notificationController = Get.put(NotificationController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      CountUnreadNotification().call(NoParams()).then((value) {
        value.fold((l) => null, (number) => notificationController.unreadNotification.value = number);
      });
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
              onPressed: () =>  Modular.to.pushNamed(IdolRoutes.user_management.notificationPage),
              icon: Icon(
                Icons.notifications_none,
                color: Colors.white,
                size: 26.sp,
              )
            ),
          ) ,
          Obx(() => notificationController.unreadNotification.value > 0 ? Center(
            child: Padding(
              padding: EdgeInsets.only(left: 29.w, bottom: 20.h),
              child: CircleAvatar(
                radius: 5.r,
                backgroundColor: Colors.amber,
              ),
            ),
          ) : Container(),)
        ],
      )
    );
  }
}
