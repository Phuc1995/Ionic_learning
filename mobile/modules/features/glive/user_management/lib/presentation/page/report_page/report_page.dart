import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widget/contact_report_widget.dart';
import 'widget/detail_report_widget.dart';
import 'widget/image_report_widget.dart';
import 'widget/send_button_report_widget.dart';
import 'widget/time_report_widget.dart';
import 'widget/type_report_widget.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBarCommonWidget _appbarCommonWidget = AppBarCommonWidget();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _appbarCommonWidget.build("report_app_bar",  (){
        Modular.to.pop();
      }),
      body: DeviceUtils.buildWidget(context, _buildBody()),
    );;
  }

  Widget _buildBody(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            TypeReportWidget(),
            SizedBox(height: 25.h,),
            DetailReportWidget(),
            SizedBox(height: 25.h,),
            TimeReportWidget(),
            SizedBox(height: 25.h,),
            ImagesWidget(),
            ContactReportWidget(),
            SizedBox(height: 25.h,),
            SendReportWidget(),
          ],
        ),
      ),
    );
  }
}
