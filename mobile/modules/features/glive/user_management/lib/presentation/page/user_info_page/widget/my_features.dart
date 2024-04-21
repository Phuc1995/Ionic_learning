import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyFeatures extends StatefulWidget {
  const MyFeatures({Key? key}) : super(key: key);

  @override
  State<MyFeatures> createState() => _MyFeaturesState();
}

class _MyFeaturesState extends State<MyFeatures> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: Text(
              'home_my'.tr,
              style: TextUtils.textStyle(FontWeight.w600, 18.sp),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildFeature(
                icon: CustomIcons.wallet,
                name: 'home_recharge'.tr,
                active: true,
                onPressed: () async {
                    Modular.to.pushNamed(ViewerRoutes.payment_crypto);
                },
              ),
              _buildFeature(
                icon: CustomIcons.money,
                name: 'home_withdraw'.tr,
                onPressed: () {},
              ),
              _buildFeature(
                icon: CustomIcons.mall,
                name: 'home_shopping'.tr,
                onPressed: () {},
              ),
              _buildFeature(
                icon: CustomIcons.crown,
                name: 'home_vip'.tr,
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFeature({
    required String name,
    required IconData icon,
    bool active = false,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.w),
              margin: EdgeInsets.only(bottom: 5.h),
              decoration: BoxDecoration(
                color: active ? AppColors.wildWatermelon :AppColors.whiteSmoke2,
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
              ),
              child: active
                  ? Icon(
                icon,
                size: 35.sp,
                color: Colors.white,
              )
                  : Icon(
                icon,
                size: 35.sp,
                color: AppColors.wildWatermelon,
              ),
            ),
            Text(
              name,
              style: TextUtils.textStyle(FontWeight.w400, 14.sp),
            ),
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}