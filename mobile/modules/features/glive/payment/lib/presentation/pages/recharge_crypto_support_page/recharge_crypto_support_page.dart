import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:payment/presentation/pages/recharge_crypto_support_page/widget/button_support_widget.dart';
import 'package:payment/presentation/pages/recharge_crypto_support_page/widget/content_support_widget.dart';

class RechargeCryptoSupportPage extends StatelessWidget {
  const RechargeCryptoSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteSmoke2,
      appBar: AppBarCommonWidget().build('payment_crypto_support_appbar_title'.tr, (){
        Modular.to.pop();
      }),
      body: DeviceUtils.buildWidget(context, _buildBody()),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentSupportWidget(),
          ButtonSupportWidget(),
        ],
      ),
    );
  }
}
