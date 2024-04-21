import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment/contants/assets.dart';
import 'package:get/get.dart';
import 'package:payment/contants/contants.dart';
import 'package:payment/controllers/recharge_crypto_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectWalletButtonWidget extends StatelessWidget {
  const ConnectWalletButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RechargeCryptoController _rechargeController = Get.put(RechargeCryptoController());
    return Center(
      child: InkWell(
        onTap: () async {
          if (!_rechargeController.wcConnector.value.connected) {
            // Create a new session
            await _rechargeController.wcConnector.value.createSession(
              chainId: _rechargeController.currentToken.value.chainId,
              onDisplayUri: (uri) async {
                var uriEncoded = '${PaymentContants.TRUST_DEEP_LINK}wc?uri=${Uri.encodeComponent(uri)}';
                if (await canLaunch(uriEncoded)) {
                  await launch(uriEncoded);
                } else {
                  await launch(PaymentContants.TRUST_GET_APP_LINK);
                }
              },
            );
          }
        },
        child: Container(
          width: 320.w,
          height: 50.h,
          decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.summerSky2
            ),
            borderRadius: BorderRadius.all(Radius.circular(40.r)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30.h,
                child: Image.asset(
                  Assets.walletConnectIcon,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Obx(() => Text(_rechargeController.wcConnectedAddress.value.isEmpty ?
              'payment_crypto_connect_wallet'.tr :
              TextUtils.maskAddress(_rechargeController.wcConnectedAddress.value, start: 10, end: _rechargeController.wcConnectedAddress.value.length - 10),
                style: TextUtils.textStyle(FontWeight.w600, 16.sp, color: AppColors.summerSky2),)),
            ],
          ),
        ),
      ),
    );
  }
}
