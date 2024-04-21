import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/presentation/page/account_complete/widget/main_title.dart';
import 'package:user_management/presentation/page/favorite/widget/category_list.dart';
import 'package:user_management/presentation/page/favorite/widget/live_button.dart';
import 'package:user_management/presentation/page/favorite/widget/more_info_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class FavoritePage extends StatelessWidget {

  const FavoritePage({Key? key}) : super(key: key);


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      primary: true,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          brightness: Brightness.light,
          actions: <Widget>[
            TextButton(
              child: Text(
                'account_verify_ignore'.tr,
                style: TextStyle(
                  color: AppColors.nobel,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Modular.to.navigate(IdolRoutes.user_management.home);
              },
            )
          ]),
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
            CategoryList(),
            SizedBox(
              height: 130.h,
            ),
            LiveButton(),
            SizedBox(
              height: 30.h,
            ),
            MoreInfoField(),
          ],
        ),
      ),
    );
  }
}
