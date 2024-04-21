import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/constants/report_filter_type.dart';
import 'package:user_management/controllers/report_controller.dart';

class TypeReportWidget extends StatelessWidget {
  const TypeReportWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReportController reportController = Get.put(ReportController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w, top: 10.h),
          child: Text("report_type_title".tr, style: TextUtils.textStyle(FontWeight.w500, 16.sp),),
        ),
        Padding(
          padding: EdgeInsets.only(left: 30.w, top: 20.h, right: 30.w),
          child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildItemType("report_type_recharge".tr, reportController, ReportFilterType.RECHARGE),
                  _buildItemType("report_type_send_gift".tr, reportController, ReportFilterType.SEND_GIFT),
                  _buildItemType("report_type_live_room".tr, reportController, ReportFilterType.LIVE_ROOM),
                ],),
              SizedBox(height: 17.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildItemType("report_type_active".tr, reportController, ReportFilterType.ACTIVE),
                  _buildItemType("report_type_other".tr, reportController, ReportFilterType.OTHER),
                  _buildItemType("report_type_request".tr, reportController, ReportFilterType.REQUEST),
                ],)
            ],
          )),
        )
      ],
    );
  }

  Widget _buildItemType(String buttonText, ReportController reportController, String typeFilter){
    return RoundedButtonGradientWidget(
      height: 38.h,
      width: 100.w,
      textSize: 13.sp,
      buttonText: buttonText,
      buttonColor: reportController.typeSelect.value == typeFilter ?
      AppColors.pinkGradientButton : AppColors.darkGradientBackground,
      textColor: reportController.typeSelect.value == typeFilter ? Colors.white : AppColors.suvaGrey,
      onPressed: (){
        reportController.changeType(typeFilter);
      },
    );
  }
}
