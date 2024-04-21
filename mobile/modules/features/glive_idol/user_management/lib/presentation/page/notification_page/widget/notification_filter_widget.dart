import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/constants/notification_filter_type.dart';
import 'package:user_management/presentation/controller/notification/notification_controller.dart';
class NotificationFilterWidget extends StatefulWidget {
  @override
  _NotificationFilterWidgetState createState() => _NotificationFilterWidgetState();
}

class _NotificationFilterWidgetState extends State<NotificationFilterWidget> {
  NotificationController _notificationController = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.w, 5.h, 0, 5.h),
      color: Colors.white,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildFilter('notification_filter_all'.tr, NotificationFilterType.ALL),
                _buildFilter('notification_filter_unread'.tr, NotificationFilterType.UNREAD),
                _buildFilter('notification_filter_system'.tr, NotificationFilterType.SYSTEM),
                _buildFilter('notification_filter_transaction'.tr, NotificationFilterType.TRANSACTION),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildFilter(String title, String typeFilter){
    return InkWell(
      child: Container(
        width: 90.w,
        height: 35.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: _notificationController.typeSelect.value == typeFilter ? AppColors.pink1 : Colors.white
        ),
        child: Center(child: Text(title, style: TextUtils.textStyle(FontWeight.w500, 15.sp, color: _notificationController.typeSelect.value == typeFilter ? Colors.white : AppColors.grayCustom1),)),
      ),
      onTap: (){
        if(_notificationController.typeSelect.value != typeFilter){
          _notificationController.changeType(typeFilter);
          _notificationController.resetFilter();
          _notificationController.getData(context);
        }
      },
    );
  }
}

