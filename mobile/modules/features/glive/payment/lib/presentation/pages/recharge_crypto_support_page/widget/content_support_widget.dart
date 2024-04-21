import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContentSupportWidget extends StatelessWidget {
  const ContentSupportWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _indexItem("payment_crypto_support_index_1".tr),
          SizedBox(height: 15.sp,),
          _contentItem("payment_crypto_support_content_1".tr),
          SizedBox(height: 30.sp,),
          _indexItem("payment_crypto_support_index_2".tr),
          SizedBox(height: 15.sp,),
          _contentItem("payment_crypto_support_content_2".tr),
          SizedBox(height: 30.sp,),
          _indexItem("payment_crypto_support_index_3".tr),
          SizedBox(height: 15.sp,),
          _contentItem("payment_crypto_support_content_3".tr),
          SizedBox(height: 30.sp,),
        ],
      ),
    );
  }

  Widget _indexItem(String str){
    return Text(str, style: TextUtils.textStyle(FontWeight.w600, 15.sp, color: AppColors.grayCustom2),);
  }

  Widget _contentItem(String str){
    return Text(str, style: TextUtils.textStyle(FontWeight.w400, 14.sp, color: AppColors.grayCustom1), textAlign: TextAlign.justify	,);
  }
}
