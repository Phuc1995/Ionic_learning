import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:payment/controllers/recharge_crypto_controller.dart';

class QuoteWidget extends StatelessWidget {
  final isManual;
  const QuoteWidget({Key? key, this.isManual = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RechargeCryptoController _rechargeController = Get.put(RechargeCryptoController());
    return Padding(
      padding: EdgeInsets.only(left: 20.w, top: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('payment_crypto_note_title'.tr, style: TextUtils.textStyle(FontWeight.w700, 14.sp, color: AppColors.pink1),),
          Obx(() => Container(
            child: Padding(
                padding: EdgeInsets.only(left: 0.w, bottom: 2.h),
                child: RichText(
                  text: TextSpan(
                    text: 'payment_crypto_note_content_1'.tr,
                    style: TextUtils.textStyle(FontWeight.w400, 15.sp,
                        color: AppColors.suvaGrey),
                    children: <TextSpan>[
                      _rechargeController.currentToken.value.symbol == null ?
                      TextSpan(
                        text: " 5 ",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          color: AppColors.pink1,
                        ),
                      ) :
                      TextSpan(
                        text: " 5 " + _rechargeController.currentToken.value.symbol.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          color: AppColors.pink1,
                        ),
                      ),
                      TextSpan(
                        text: 'payment_crypto_note_content_2'.tr,
                        style: TextUtils.textStyle(FontWeight.w400, 15.sp,
                            color: AppColors.suvaGrey),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                )),
          )),
        ],
      ),
    );
  }
}
