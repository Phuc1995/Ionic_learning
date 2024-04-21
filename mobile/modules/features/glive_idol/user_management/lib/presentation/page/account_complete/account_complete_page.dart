import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/presentation/page/account_complete/widget/build_hint.dart';
import 'package:user_management/presentation/page/account_complete/widget/build_verify_button.dart';
import 'package:user_management/presentation/page/account_complete/widget/main_title.dart';
import 'package:get/get.dart';
import 'package:common_module/common_module.dart';

class AccountCompletePage extends StatelessWidget {
  const AccountCompletePage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Modular.to.navigate(IdolRoutes.user_management.home);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        primary: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          brightness: Brightness.light,
        ),
        body: SafeArea(child: DeviceUtils.buildWidget(context, _buildBody(context))),
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          _buildMainContent(context),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            MainTitleWidget(
              title: 'account_complete_title'.tr,
              bottom: 35.h,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Center(
                child: AppIconWidget(
                  image: Assets.shieldIcon,
                  size: 155.sp,
                  height: 140.h,
                ),
              ),
            ),
            BuildHint(),
            SizedBox(
              height: 32.h,
            ),
            BuildVerifyWidget(),
            TextButton(
              child: Text(
                'account_verify_ignore'.tr,
                style: TextUtils.textStyle(
                  FontWeight.w400,
                  14.sp,
                  color: AppColors.nobel,
                ),
              ),
              onPressed: () {
                    Modular.to.navigate(IdolRoutes.user_management.home);
              },
            ),
          ],
        ),
      ),
    );
  }
}
