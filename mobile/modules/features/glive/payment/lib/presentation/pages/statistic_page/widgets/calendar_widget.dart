import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:payment/contants/filter_type.dart';
import 'package:payment/contants/assets.dart';
import 'package:payment/controllers/statistic_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarWiget extends StatefulWidget {
  @override
  _CalendarWigetState createState() => _CalendarWigetState();
}

class _CalendarWigetState extends State<CalendarWiget> {
  StatisticController _statisticController = Get.put(StatisticController());
  final logger = Modular.get<Logger>();

  String _dateFromSelect = '';
  String _dateToSelect = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteSmoke8,
      width: double.infinity,
      child: Obx(() => InkWell(
            onTap: () => {
              if (_statisticController.typeSelect != FilterType.week)
                {this.showAlertDialog(context)}
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _statisticController.typeSelect != FilterType.week
                    ? Container(
                        margin: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 15.h),
                        width: 25.w,
                        height: 25.h,
                        child: Image.asset(Assets.calendarIcon))
                    : SizedBox(
                        height: 55.h,
                      ),
                Text(
                  _statisticController.showFilter(),
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: AppColors.pink1),
                )
              ],
            ),
          )),
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      actions: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          RoundedButtonWidget(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            height: 36.h,
            buttonText: 'payment_statistic_app_bar_title'.tr,
            buttonColor: AppColors.pink1,
            textColor: Colors.white,
            textSize: 12.sp,
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            onPressed: () {
              if (_statisticController.typeSelect == FilterType.month &&
                  _dateToSelect == _dateFromSelect) {
                _statisticController.toDate.value = DateFormat('dd-MM-yyyy').format(DateTime.utc(
                  DateFormat("dd-MM-yyyy").parse(_dateFromSelect).year,
                  DateFormat("dd-MM-yyyy").parse(_dateFromSelect).month + 1,
                ).subtract(Duration(days: 1)));
              } else {
                _statisticController.toDate.value = _dateToSelect;
              }
              _statisticController.fromDate.value = _dateFromSelect;
              _statisticController.resetFilterController();
              _statisticController.getDataStatistic();
              Navigator.pop(context);
            },
          )
        ])
      ],
      content: Obx(
        () => Container(
          width: 500.w,
          height: 400.h,
          child: SfDateRangePicker(
            allowViewNavigation: false,
            view: _statisticController.typeSelect == FilterType.day
                ? DateRangePickerView.month
                : DateRangePickerView.year,
            onSelectionChanged: _onSelectionChanged,
            selectionMode: DateRangePickerSelectionMode.range,
            maxDate: DateTime.now(),
            initialSelectedRange: PickerDateRange(
              DateFormat("dd-MM-yyyy").parse(_statisticController.fromDate.value),
              DateFormat("dd-MM-yyyy").parse(_statisticController.toDate.value),
            ),
          ),
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _dateFromSelect = DateFormat('dd-MM-yyyy').format(args.value.startDate);
        _dateToSelect =
            DateFormat('dd-MM-yyyy').format(args.value.endDate ?? args.value.startDate).toString();
      }
    });
  }


}
