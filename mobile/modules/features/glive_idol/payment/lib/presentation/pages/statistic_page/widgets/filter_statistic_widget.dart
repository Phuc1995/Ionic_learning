import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payment/contants/filter_type.dart';
import 'package:payment/controllers/statistic_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListFilterStatisticWidget extends StatefulWidget {
  @override
  _ListFilterStatisticWidgetState createState() => _ListFilterStatisticWidgetState();
}

class _ListFilterStatisticWidgetState extends State<ListFilterStatisticWidget> {
  StatisticController _statisticController = Get.put(StatisticController());
  ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (_statisticController.currentPage.value >= _statisticController.totalPage.value) {
          ShowShortMessage().show(context: context, message: "payment_statistic_loading_paging".tr, second: 2);
        } else {
          _statisticController.isLoading.value = true;
          _statisticController.currentPage += 1;
          _statisticController.getDataStatistic(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double withScale = DeviceUtils.getWidthDevice(context) / 100;
    return Container(
      child: Column(
        children: [
          _buildTitle(),
          Row(
            children: [
              _buildListItemTitle(context, "payment_statistic_day".tr, "payment_statistic_hour".tr,
                  "payment_statistic_fan_new".tr, "payment_statistic_ruby_new".tr, withScale),
              _buildListItem(context, withScale),
            ],
          ),
          // _buildListItem(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 84.h,
      color: ConvertCommon().hexToColor("#FF5783"),
      child: Obx(() => Row(
            children: [
              _buildItemTitle(_statisticController.summaryObject.value.totalDate.toString(),
                  "payment_statistic_day".tr),
              _buildItemTitle(
                  ConvertCommon()
                      .formatSecondDuration(_statisticController.summaryObject.value.totalLiveTime),
                  "payment_statistic_hour".tr),
              _buildItemTitle(_statisticController.summaryObject.value.totalFan.toString(),
                  "payment_statistic_fan_new".tr),
              _buildItemTitle(_statisticController.summaryObject.value.totalRuby.toString(),
                  "payment_statistic_ruby_new".tr)
            ],
          )),
    );
  }

  Widget _buildItemTitle(String number, String title) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              number,
              style: TextStyle(
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: 6.h,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildListItemTitle(
      BuildContext context, String type, String hours, String fans, String rubys, double scale) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: scale * 25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Align(
                    child: Container(
                      margin: EdgeInsets.only(left: 15.w),
                      height: 70.h,
                      alignment: Alignment.centerLeft,
                      child: Obx(() => Text(
                            _convertType(_statisticController.typeSelect.value),
                            style: TextStyle(
                                fontSize: 17.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                  ),
                  Align(
                    child: Container(
                      height: 70.h,
                      color: ConvertCommon().hexToColor("#F8F8F8"),
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Text(
                          hours,
                          style: TextStyle(
                              fontSize: 17.sp, color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    child: Container(
                      margin: EdgeInsets.only(left: 15.sp),
                      height: 70.h,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        fans,
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    child: Container(
                      height: 70.h,
                      color: ConvertCommon().hexToColor("#F8F8F8"),
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Text(
                          rubys,
                          style: TextStyle(
                              fontSize: 17.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Container(
                width: 2.w,
                height: 280.h,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createListItem(
      BuildContext context, double scale, StatisticController statisticController, int index) {
    return Obx(() => Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: scale * 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Align(
                        child: Container(
                          margin: EdgeInsets.only(left: 15.w),
                          height: 70.h,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            statisticController.listItemStatistic[index].timeLine,
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: ConvertCommon().hexToColor("#FF5783"),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Align(
                        child: Container(
                          height: 70.h,
                          color: ConvertCommon().hexToColor("#F8F8F8"),
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.w),
                            child: Text(
                              ConvertCommon().formatSecondDuration(
                                  statisticController.listItemStatistic[index].liveTime),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        child: Container(
                          margin: EdgeInsets.only(left: 15.w),
                          height: 70.h,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            statisticController.listItemStatistic[index].fan.toString(),
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Align(
                        child: Container(
                          height: 70.h,
                          color: ConvertCommon().hexToColor("#F8F8F8"),
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.w),
                            child: Text(
                              statisticController.listItemStatistic[index].ruby.toString(),
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 2.w,
                    height: 280.h,
                    color: ConvertCommon().hexToColor("#E8E8E8"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildListItem(BuildContext context, double scale, {bool? isItem}) {
    return Container(
      height: 280.h,
      width: scale * 75,
      child: Obx(() => Stack(
            children: [
              ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: _statisticController.listItemStatistic.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _createListItem(context, scale, _statisticController, index);
                  }),
              Visibility(
                  visible: _statisticController.isLoading.value,
                  child: CustomProgressIndicatorWidget())
            ],
          )),
    );
  }
}

String _convertType(String type) {
  String result = '';
  switch (type) {
    case FilterType.day:
      result = "payment_statistic_day".tr;
      break;
    case FilterType.week:
      result = "payment_statistic_week".tr;
      break;
    case FilterType.month:
      result = "payment_statistic_month".tr;
      break;
  }
  return result;
}
