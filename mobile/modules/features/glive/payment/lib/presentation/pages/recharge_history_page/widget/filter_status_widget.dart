import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:payment/contants/contants.dart';
import 'package:payment/controllers/recharge_history_controller.dart';
import 'package:payment/ultil/recharge_convert.dart';

class FilterStatusWidget extends StatelessWidget {
  const FilterStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RechargeHistoryController _controller = Get.put(RechargeHistoryController());
    return Container(
      width: double.infinity,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 27.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _createItem(_controller, PaymentContants.ALL, context),
                _createItem(_controller, PaymentContants.PROCESSING, context),
                _createItem(_controller, PaymentContants.COMPLETED, context),
                _createItem(_controller, PaymentContants.FAILED, context)
              ],
            ),
          ),
          SizedBox(height: 15.h,)
        ],
      ),
    );
  }

  Widget _createItem(RechargeHistoryController controller, String title, BuildContext context){
    return InkWell(
      onTap: (){
        if( controller.statusFilter.value != title){
          controller.statusFilter.value = title;
          controller.listData.clear();
          controller.getData();
        }
      },
      child: Obx(() => Container(
        height: 35.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.r)),
            border: Border.all(color: controller.statusFilter.value == title ? AppColors.pinkLiveButtonCustom : Colors.white)
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              RechargeConvert().convertTitleStatus(title),
              style: TextUtils.textStyle(FontWeight.w400, 14.sp, color: controller.statusFilter.value == title ? AppColors.pink2 :AppColors.grey3),),
          ),
        ),
      )),
    );
  }

}
