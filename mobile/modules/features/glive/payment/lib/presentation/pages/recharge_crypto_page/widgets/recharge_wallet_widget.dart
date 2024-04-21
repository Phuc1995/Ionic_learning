import 'dart:convert';
import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:payment/contants/assets.dart';
import 'package:payment/contants/contants.dart';
import 'package:payment/controllers/recharge_crypto_controller.dart';
import 'package:payment/dto/dto.dart';
import 'package:payment/presentation/pages/recharge_crypto_page/widgets/crypto_network_type_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment/presentation/pages/recharge_crypto_page/widgets/crypto_package_recharge_widget.dart';
import 'package:get/get.dart';
import 'package:payment/presentation/pages/recharge_crypto_page/widgets/quote_widget.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';

class RechargeWalletWidget extends StatefulWidget {
  RechargeWalletWidget({Key? key}) : super(key: key);

  _RechargeWalletState createState() => _RechargeWalletState();
}

class _RechargeWalletState extends State<RechargeWalletWidget> {
  final RechargeCryptoController _rechargeController  = Get.put(RechargeCryptoController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 35.h,),
                CryptoNetworkTypeWidget(),
                SizedBox(height: 15.h,),
                CryptoPackageRechargeWidget(),
                SizedBox(height: 15.h,),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15.h),
            color: AppColors.whiteSmoke2,
            child: Padding(
              padding: EdgeInsets.only(top: 0.h, left: 17.w, right: 17.w),
              child: Obx(() => RoundedButtonGradientWidget(
                iconAsset: Assets.trustWhiteIcon,
                buttonText: 'payment_crypto_recharge_wallet'.tr,
                buttonColor:  _rechargeController.packageSelect.value != 0 ? AppColors.pinkGradientButton : AppColors.darkGradientBackground,
                textColor: Colors.white,
                width: double.infinity,
                height: 50.h,
                onPressed: _rechargeController.packageSelect.value != 0 ? () async {
                  _rechargeController.sendTokenTrustWallet(
                    coinId: _rechargeController.currentNetwork.value.coinId!,
                    contractAddress: _rechargeController.currentToken.value.address!,
                    address: _rechargeController.currentNetwork.value.walletAddress!,
                    amount: _rechargeController.packageSelect.value,
                  );
                  Modular.to.pushNamed(ViewerRoutes.payment_information, arguments: {'information': RechargeInformationDto(
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
                  )});
                } : null,
                textSize: 16.sp,
              )),
            ),
          ),
          QuoteWidget()
        ],
      ),
    );
  }

  requestPayment() async {
    final provider = EthereumWalletConnectProvider(_rechargeController.wcConnector.value);
    final sender = EthereumAddress.fromHex(_rechargeController.wcConnectedAddress.value);
    final receiver =
    EthereumAddress.fromHex(_rechargeController.currentNetwork.value.walletAddress??'');
    final contract =
    await getContractAbi(_rechargeController.currentToken.value.address!);
    final amount = BigInt.from(_rechargeController.packageSelect.value) *
        BigInt.from(10).pow(
            int.parse((_rechargeController.currentToken.value.decimals ?? 18)
                .toString()));
    final transaction = Transaction.callContract(
      contract: contract,
      function: contract.function('transfer'),
      parameters: [receiver, amount],
      from: sender,
    );
    try {
      // Sign the transaction
      _rechargeController.loading.value = true;
      final result = await provider.sendTransaction(
        from: sender.toString(),
        to: _rechargeController.currentToken.value.address,
        data: transaction.data,
      );
      _rechargeController.loading.value = false;
      print(result);
    } catch (e) {
      _rechargeController.loading.value = false;
      print(e);
    }
  }

  Future<DeployedContract> getContractAbi(String contractAddress) async {
    final contractJson =
    jsonDecode(await rootBundle.loadString('assets/token-abi.json'));
    return DeployedContract(
        ContractAbi.fromJson(jsonEncode(contractJson), 'token-abi'),
        EthereumAddress.fromHex(contractAddress));
  }
}
