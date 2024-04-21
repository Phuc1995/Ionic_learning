import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment/contants/assets.dart';
import 'package:payment/controllers/recharge_crypto_controller.dart';

class AddressWalletWidget extends StatelessWidget {
  const AddressWalletWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RechargeCryptoController _rechargeController  = Get.put(RechargeCryptoController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "payment_crypto_manual_address".tr,
          style: TextUtils.textStyle(FontWeight.w400, 15.sp,
              color: AppColors.suvaGrey),
        ),
        SizedBox(height: 10.h,),
        InkWell(
          onTap: (){
            Clipboard.setData(ClipboardData(text: _rechargeController.currentNetwork.value.walletAddress??'')).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'home_copied'.tr,
                    style: TextUtils.textStyle(FontWeight.w500, 19.sp,
                        color: Colors.white),
                  )));
            });
          },
          child: Container(
            width: 380.w,
            height: 35.h,
            decoration: BoxDecoration(
              border:  Border.all(color: AppColors.gainsboro, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(5.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => _address(context, _rechargeController, 380.w)),
                Container(
                    padding: EdgeInsets.only(right: 10.w),
                    width: 30.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Assets.copy,)),
                    )
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _address(BuildContext context, RechargeCryptoController _rechargeController, double widthParent){
    final Size size = TextUtils.getSizeText(context, _rechargeController.currentNetwork.value.walletAddress!, TextUtils.textStyle(FontWeight.w500, 14.sp));
    String str = '';
    if(size.width + 90.w > widthParent){
      final address = _rechargeController.currentNetwork.value.walletAddress??'';
      str = TextUtils.maskAddress(_rechargeController.currentNetwork.value.walletAddress??'', start: 16, end: address.length - 16);
    } else {
      str = _rechargeController.currentNetwork.value.walletAddress!;
    }
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: Text(str, style: TextUtils.textStyle(FontWeight.w500, 14.sp),),
    );
  }
}
