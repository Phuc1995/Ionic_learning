import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payment/contants/filter_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment/controllers/statistic_controller.dart';
class Statistic extends StatefulWidget {
  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  StatisticController _statisticController = Get.put(StatisticController());
  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    _statisticController.getDataStatistic();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 22.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RoundedButtonWidget(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  height: 50.h,
                  border: Border.all(color: AppColors.whiteSmoke5),
                  buttonText: 'payment_statistic_type_title_day'.tr,
                  buttonColor: _statisticController.typeSelect.value == FilterType.day
                      ? AppColors.pink1
                      : Colors.transparent,
                  textColor: _statisticController.typeSelect.value == FilterType.day
                      ? Colors.white
                      : Colors.black,
                  textSize: 18.sp,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  onPressed: () => _statisticController.onPressed(FilterType.day),
                ),
                RoundedButtonWidget(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  height: 50.h,
                  border: Border.all(color: AppColors.whiteSmoke5),
                  buttonText: 'payment_statistic_type_title_week'.tr,
                  buttonColor: _statisticController.typeSelect.value == FilterType.week
                      ? AppColors.pink1
                      : Colors.transparent,
                  textColor: _statisticController.typeSelect.value == FilterType.week
                      ? Colors.white
                      : Colors.black,
                  textSize: 18.sp,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  onPressed: () => _statisticController.onPressed(FilterType.week),
                ),
                RoundedButtonWidget(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  height: 50.h,
                  border: Border.all(color: AppColors.whiteSmoke5),
                  buttonText: 'payment_statistic_type_title_month'.tr,
                  buttonColor: _statisticController.typeSelect.value == FilterType.month
                      ? AppColors.pink1
                      : Colors.transparent,
                  textColor: _statisticController.typeSelect.value == FilterType.month
                      ? Colors.white
                      : Colors.black,
                  textSize: 18.sp,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  onPressed: () => _statisticController.onPressed(FilterType.month),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}

