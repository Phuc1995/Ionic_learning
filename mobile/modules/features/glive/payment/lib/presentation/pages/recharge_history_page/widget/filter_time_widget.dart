import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:payment/controllers/recharge_history_controller.dart';

class FilterTimeWidget extends StatefulWidget {
  const FilterTimeWidget({Key? key}) : super(key: key);

  @override
  State<FilterTimeWidget> createState() => _FilterTimeWidgetState();
}

class _FilterTimeWidgetState extends State<FilterTimeWidget> {
  RechargeHistoryController _controller = Get.put(RechargeHistoryController());
  final inputFormat = new DateFormat(Strings.DATE_FORMAT);
  DateTime? nowDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime? date = new DateTime(nowDate!.year, nowDate!.month, nowDate!.day-7);
    _controller.tmpTime.value = date;
    _controller.startDayFilter.value = inputFormat.format(date);
    _controller.endDayFilter.value = inputFormat.format( new DateTime(nowDate!.year, nowDate!.month, nowDate!.day));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 27.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("payment_history_time".tr, style: TextUtils.textStyle(FontWeight.w500, 14.sp, color: AppColors.grayCustom2),),
          SizedBox(height: 12.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () async {
                    DateTime? date = new DateTime(nowDate!.year, nowDate!.month, nowDate!.day-7);
                    date = await showDatePicker(
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        context: context,
                        initialDate: DateTime(nowDate!.year, nowDate!.month, nowDate!.day-7),
                        firstDate: DateTime(1900, 1, 1),
                        lastDate: new DateTime(nowDate!.year , nowDate!.month, nowDate!.day));
                    _controller.tmpTime.value = date!;
                    _controller.startDayFilter.value = inputFormat.format(date);;

                  },
                  child: Obx(() => _createItemStartDay(_controller.startDayFilter.value))),
              Text("payment_history_to".tr, style: TextUtils.textStyle(FontWeight.w500, 14.sp),),
              InkWell(
                  onTap: () async {
                    DateTime? date = new DateTime(nowDate!.year, nowDate!.month, nowDate!.day);
                    date = await showDatePicker(
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        context: context,
                        initialDate: DateTime(nowDate!.year, nowDate!.month, nowDate!.day),
                        firstDate: _controller.tmpTime.value,
                        lastDate: new DateTime(nowDate!.year , nowDate!.month, nowDate!.day));
                    _controller.endDayFilter.value = inputFormat.format(date!);;

                  },
                  child: Obx(() => _createItem(_controller.endDayFilter.value))),
            ],
          )
        ],
      ),
    );
  }

  Widget _createItemStartDay(String day){
    return Container(
      height: 35.h,
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey4)
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 17.w),
          child: Text(
            day,
            style: TextUtils.textStyle(FontWeight.w400, 14.sp, color: AppColors.grey3),),
          ),
      ),
    );
  }

  Widget _createItem(String title){
    return Container(
      height: 35.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey4)
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 17.w),
          child: Text(
            title,
            style: TextUtils.textStyle(FontWeight.w400, 14.sp, color: AppColors.grey3),),
        ),
      ),
    );
  }
}
