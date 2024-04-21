import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../controllers/notification_controller.dart';

class AppbarWidget {
  AppBar appBar(){
    NotificationController notificationController = Get.put(NotificationController());
    return AppBar(
      toolbarHeight: 50.h,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFE92B7A), Color(0xFFFF9D88)],
              begin: Alignment(-0.1, -1),
              end: Alignment(0.03, 1.5))
        ),
      ),
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 7,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    TextButton(
                      child: Text('Phổ biến', style: TextStyle(color: Colors.white, fontSize: 18.sp),),
                      onPressed: () {},
                    ),
                    TextButton(
                      child: Text('Gần đây', style: TextStyle(color: Colors.white, fontSize: 16.sp),),
                      onPressed: () {
                      },
                    ),
                    TextButton(
                      child: Text('Hẹn hò', style: TextStyle(color: Colors.white, fontSize: 16.sp),),
                      onPressed: () {},
                    ),
                    TextButton(
                      child: Text('Trò chơi', style: TextStyle(color: Colors.white, fontSize: 16.sp),),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
        ],),
      ),
      actions: [
        _buildCrownButton(),
        _buildSearchButton(),
        _buildNotificationButton(notificationController),
      ],
    );
  }

  Widget _buildCrownButton() {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        CustomIcons.crown,
        color: Colors.white,
        size: 18.sp,
      ),
    );
  }

  Widget _buildSearchButton() {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.search,
        color: Colors.white,
        size: 18.sp,
      ),
    );
  }

  Widget _buildNotificationButton(NotificationController controller) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () =>  Modular.to.pushNamed(ViewerRoutes.notification_page),
          icon: Icon(
            Icons.notifications_none,
            color: Colors.white,
            size: 18.sp,
          ),
        ),
        Positioned(
          top: 16.0.h,
          right: 16.w,
          width: 8.0.w,
          height: 8.0.h,
          child:Obx(() =>  controller.unreadNotification.value > 0 ? Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE80000),
            ),
          ): Container()) ,
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}
