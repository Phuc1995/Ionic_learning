import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payment/contants/assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import 'package:payment/controllers/controllers.dart';

class MoneyTopUpSelectorWidget extends StatelessWidget {
  final String title;
  final Widget titleIcon;
  final PaymentTopUpController controller;

  MoneyTopUpSelectorWidget({
    Key? key,
    required this.title,
    required this.titleIcon,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.h),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              titleIcon,
              SizedBox(
                width: 8.h,
              ),
              Text(title)
            ],
          ),
          SizedBox(
            height: 25.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('payment_money_deposit'.tr),
              Text(
                'payment_money_range'.tr,
                style: TextStyle(color: AppColors.nobel),
              ),
            ],
          ),
          Container(
              padding: EdgeInsets.symmetric(vertical: 25.h),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: AppColors.whiteSmoke12,
                  ),
                ),
              ),
              child: controller.numMoney.value > 0
                  ? Text(
                  controller.numMoney.value.formatCurrency() +
                          'payment_money_vnd'.tr,
                      style: TextStyle(
                          fontSize: 22.sp, fontWeight: FontWeight.w600))
                  : Text(
                      'payment_money'.tr,
                      style: TextStyle(
                          fontSize: 22.sp,
                          color: AppColors.nobel,
                          fontWeight: FontWeight.w600),
                    )),
          SizedBox(
            height: 25.h,
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: controller.moneyOptions
                .map((value) => _buildMoneyItem(context,
                    value: value, selected: value == controller.numMoney.value))
                .toList(),
          ),
          SizedBox(
            height: 15.h,
          ),
        ],
      ),
    );
  }

  Widget _buildMoneyItem(BuildContext context,
      {required num value, bool selected = true}) {
    return InkWell(
      onTap: () => controller.numMoney.value = value,
      child: Container(
        width: 120.w,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: selected ? AppColors.pink[500]! : AppColors.whiteSmoke4),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Image.asset(Assets.diamondIcon, width: 10.w,),
              SizedBox(width: 5.sp,),
              Text(
                _vndToRuby(value).toString(),
                style: TextStyle(
                    color: selected ? AppColors.pink[500]! : AppColors.suvaGrey,
                    fontWeight: FontWeight.w600, fontSize: 20.sp
                ),
              ),
            ],),
            Text(
              value.formatCurrency() + 'payment_money_vnd'.tr,
              style: TextStyle(
                  color: selected ? AppColors.pink[500]! : AppColors.suvaGrey),
            ),
          ],
        ),
      ),
    );
  }

  num _vndToRuby(num value) {
    return (value / 1000).round();
  }
}
