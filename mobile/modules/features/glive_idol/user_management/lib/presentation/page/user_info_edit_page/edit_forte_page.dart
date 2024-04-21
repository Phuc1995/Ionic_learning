import 'package:common_module/common_module.dart';
import 'package:common_module/utils/device/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/presentation/page/account_complete/widget/main_title.dart';
import 'package:user_management/presentation/page/favorite/widget/live_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/presentation/page/user_info_edit_page/widget/category_list_widget.dart';
import 'package:user_management/presentation/page/user_info_edit_page/widget/complete_button_widget.dart';


class EditFortePage extends StatelessWidget {

  const EditFortePage({Key? key}) : super(key: key);


  Widget build(BuildContext context) {
    AppBarCommonWidget _appBarCommonWidget = AppBarCommonWidget();
    return Scaffold(
      backgroundColor: Colors.white,
      primary: true,
      appBar: _appBarCommonWidget.build("edit_user_info_edit_forte_title".tr, (){
        Modular.to.pop();
      }),
      body: SafeArea(child: DeviceUtils.buildWidget(context, _buildBody())),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          _buildMainContent(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            MainTitleWidget(
              title: 'favorite_title'.tr,
              bottom: 35.h,
            ),
            CategoryListWidget(),
            SizedBox(
              height: 130.h,
            ),
            CompleteButtonWidget(),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }
}
