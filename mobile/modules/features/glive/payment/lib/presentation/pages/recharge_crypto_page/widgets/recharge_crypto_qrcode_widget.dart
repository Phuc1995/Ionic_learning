import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:payment/controllers/recharge_crypto_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RechargeCryptoQrCodeWidget extends StatelessWidget {
  const RechargeCryptoQrCodeWidget(
      {Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RechargeCryptoController _rechargeController  = Get.put(RechargeCryptoController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 15.h,),
        Container(
          margin: EdgeInsets.only(left: 60.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(()=> QrImage(
                data: _rechargeController.currentNetwork.value.walletAddress??'', size: 150.h,
              ),),
              Container(
                width: 160.w,
                child: Text('payment_crypto_manual_qr_content'.tr, style: TextUtils.textStyle(FontWeight.w400, 13.sp, color: AppColors.suvaGrey),),
              )
            ],
          ),
        ),
        SizedBox(height: 10.h,),
        Container(
          height: 30.h,
          width: 380.w,
          decoration: BoxDecoration(
            gradient: AppColors.suvaGreyGradientBackground,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Obx(() => Text('*1 ${_rechargeController.currentToken.value.symbol} = 10 Ruby', textAlign: TextAlign.left, style: TextUtils.textStyle(FontWeight.w400, 13.sp, color: AppColors.pink2),))),
          ),
        ),
        SizedBox(height: 30.h,),
      ],
    );
  }
}
