import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:payment/contants/contants.dart';
import 'package:payment/controllers/recharge_crypto_controller.dart';
import 'package:payment/dto/dto.dart';
import 'package:payment/presentation/pages/recharge_crypto_page/widgets/address_wallet_widget.dart';
import 'package:payment/presentation/pages/recharge_crypto_page/widgets/crypto_network_type_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment/presentation/pages/recharge_crypto_page/widgets/quote_widget.dart';
import 'package:payment/presentation/pages/recharge_crypto_page/widgets/recharge_crypto_qrcode_widget.dart';
import 'package:get/get.dart';
import 'package:payment/service/top_up_service.dart';

class RechargeManualWidget extends StatelessWidget {
  const RechargeManualWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RechargeCryptoController _rechargeController  = Get.put(RechargeCryptoController());
    final _topUpService = Modular.get<TopUpService>();
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h,),
                CryptoNetworkTypeWidget(),
                SizedBox(height: 15.h,),
                AddressWalletWidget(),
                RechargeCryptoQrCodeWidget(),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15.h),
            color: AppColors.whiteSmoke2,
            child: Padding(
              padding: EdgeInsets.only(top: 0.h, left: 17.w, right: 17.w),
              child: RoundedButtonGradientWidget(
                buttonText: 'payment_crypto_manual_button'.tr,
                buttonColor: AppColors.pinkGradientButton,
                textColor: Colors.white,
                width: double.infinity,
                height: 50.h,
                onPressed: () async {
                  RechargeInformationDto information = RechargeInformationDto(
                    type: _rechargeController.currentType.value,
                    tokenType: _rechargeController.currentToken.value.type,
                    tokenSymbol: _rechargeController.currentToken.value.symbol == null ? "" : _rechargeController.currentToken.value.symbol,
                    addressTo: _rechargeController.currentNetwork.value.walletAddress == null ? "" : _rechargeController.currentNetwork.value.walletAddress!,
                    status: StatusType.MANUAL_WAITING_RECHARGE.name,
                    isCompleted: false,
                    networkName: _rechargeController.currentNetwork.value.name!,
                    txPath:  _rechargeController.currentNetwork.value.txPath,
                    accountPath:  _rechargeController.currentNetwork.value.accountPath,
                    explorerUrl:  _rechargeController.currentNetwork.value.explorerUrl,
                    ttl: PaymentContants.TTL,
                  );
                  var topTopCache = await _topUpService.postTopUpCache(information);
                  topTopCache.fold((l) => null, (data) {
                    Modular.to.pushNamed(ViewerRoutes.payment_information, arguments: {'information': information});
                  });
                },
                textSize: 16.sp,
              ),
            ),
          ),
          QuoteWidget(isManual: true,)
        ],
      ),
    );
  }
}
