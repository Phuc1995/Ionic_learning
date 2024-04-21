import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/controllers/report_controller.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';

class DetailReportWidget extends StatefulWidget {
  const DetailReportWidget({Key? key}) : super(key: key);

  @override
  _DetailReportWidgetState createState() => _DetailReportWidgetState();
}

class _DetailReportWidgetState extends State<DetailReportWidget> {
  final ReportController _reportController =  Get.put(ReportController());
  TextEditingController _textEditingController = TextEditingController();
  final int maxLength = 1000;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w, top: 10.h),
          child: Text("report_detail_title".tr, style: TextUtils.textStyle(FontWeight.w500, 16.sp),),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.w, top: 20.h, right: 15.w),
          child: Container(
            height: 140,
            color: AppColors.whiteSmoke2,
            child: TextFieldWidget(
              hint: "report_detail_hint".tr,
              maxLines: true,
              filled: true,
              radiusCustom: BorderRadius.circular(5.r),
              contentPadding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
              fillColor: AppColors.whiteSmoke2,
              maxLength: maxLength,
              padding: EdgeInsets.only(top: 0.0),
              textController: _textEditingController,
              inputType: TextInputType.text,
              onChanged: (value) {
                _reportController.detailLength.value = _textEditingController.text.length;
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.w, top: 0.h, right: 15.w),
          child: Container(
            height: 25,
            color: AppColors.whiteSmoke2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(""),
                Obx(() => Container(
                  margin: EdgeInsets.only(right: 10.w, bottom: 5.h),
                  child: Text("${_reportController.detailLength.value}/${maxLength}"),
                ))
              ],
            ),
          ),
        )
      ],
    );
  }

}
