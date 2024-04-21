import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:user_management/controllers/report_controller.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';

class TimeReportWidget extends StatefulWidget {
  const TimeReportWidget({Key? key}) : super(key: key);

  @override
  _TimeReportWidgetState createState() => _TimeReportWidgetState();
}

class _TimeReportWidgetState extends State<TimeReportWidget> {
  TextEditingController _birthdateController = TextEditingController();
  final df = new DateFormat('dd-MM-yyyy');
  final ReportController _reportController =  Get.put(ReportController());

  @override
  void dispose() {
    _birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w, top: 10.h),
          child: Text("report_time_title".tr, style: TextUtils.textStyle(FontWeight.w500, 16.sp),),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.w, top: 20.h, right: 15.w),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: AppColors.whiteSmoke2,
            ),
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(AppColors.whiteSmoke2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 20.h,
                    width: 200.w,
                    child: TextFieldWidget(
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                      textController: _birthdateController,
                      inputType: TextInputType.datetime,
                      hint: ('report_time_content').tr,
                      filled: true,
                      contentPadding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
                      fillColor: Color(0xFFF6F6F6),
                      onTap: (){
                        _selectDate(context);
                      },
                      validator: validateBirthdate,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.grayCustom1,
                    size: 24.sp,
                  ),
                ],
              ),
              onPressed:  () async {
                _selectDate(context);
              },
            ),
          ),
        )
      ],
    );

  }

  void _selectDate(BuildContext context) async {
    DateTime? nowDate = DateTime.now();
    DateTime? date = new DateTime(nowDate.year - 18, nowDate.month, nowDate.day);
    FocusScope.of(context).requestFocus(new FocusNode());
    date = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: _birthdateController.text != ''
            ? DateFormat('dd-MM-yyyy').parse(_birthdateController.text)
            : new DateTime(nowDate.year - 18, nowDate.month, nowDate.day),
        firstDate: DateTime(1900, 1, 1),
        lastDate: new DateTime(nowDate.year - 18, nowDate.month, nowDate.day));
    _birthdateController.text = df.format(date!);
    var inputFormat = DateFormat("dd-MM-yyyy");
    var birthdate = inputFormat.parse(_birthdateController.text);
  }

  String? validateBirthdate(value) {
    if (value == null || value.isEmpty) {
      return ('report_time_content').tr;
    }
    return null;
  }

}

