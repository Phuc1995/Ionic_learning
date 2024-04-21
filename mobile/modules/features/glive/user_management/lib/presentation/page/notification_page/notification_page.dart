import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/notification_controller.dart';
import 'widget/list_item_notification.dart';
import 'widget/notification_filter_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotificationController _notificationController = Get.put(NotificationController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
        title: Obx(() => Container(
              child: Text(
                "notification_app_bar_title".tr +
                    " ${_notificationController.unreadNotification.value > 0 ? "(${_notificationController.unreadNotification.value})" : ""} ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
            )),
        leading: IconButton(
          iconSize: 24.sp,
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Modular.to.pop();
          },
        ),
        actions: [],
      ),
      body: DeviceUtils.buildWidget(context, _buildBody()),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          NotificationFilterWidget(),
          ListItemNotification(),
          // ListFilterStatisticWidget(),
        ],
      ),
    );
  }
}
