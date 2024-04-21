import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';

class ContactReportWidget extends StatefulWidget {
  const ContactReportWidget({Key? key}) : super(key: key);

  @override
  _ContactReportWidgetState createState() => _ContactReportWidgetState();
}

class _ContactReportWidgetState extends State<ContactReportWidget> {
  TextEditingController _textEditingController = TextEditingController();

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
          child: Text("report_contact_title".tr, style: TextUtils.textStyle(FontWeight.w500, 16.sp),),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.w, top: 20.h, right: 15.w),
          child: Container(
            height: 50.h,
            color: AppColors.whiteSmoke2,
            child: TextFieldWidget(
              hint: "report_contact_content".tr,
              filled: true,
              radiusCustom: BorderRadius.circular(5.r),
              fillColor: AppColors.whiteSmoke2,
              maxLength: 50,
              padding: EdgeInsets.only(top: 0.0),
              textController: _textEditingController,
              inputType: TextInputType.text,
              errorText: null,
              errorStyle: TextStyle(color: AppColors.mahogany),
              onChanged: (value) {
              },
            ),
          ),
        ),
      ],
    );
  }

}
