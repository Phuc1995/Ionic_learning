import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:payment/contants/assets.dart';
import 'package:payment/controllers/controllers.dart';
import 'package:payment/dto/dto.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:common_module/presentation/widget/app_bar/app_bar_common.dart';
import 'package:payment/presentation/widget/money_top_up_selector.dart';
import 'package:payment/service/top_up_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentMomoPage extends StatefulWidget {
  PaymentMomoPage({Key? key}) : super(key: key);

  _PaymentMomoPageState createState() => _PaymentMomoPageState();
}

class _PaymentMomoPageState extends State<PaymentMomoPage> {
  late PaymentTopUpController _topUpController;
  final _topUpService = Modular.get<TopUpService>();
  @override
  void initState() {
    _topUpController = Get.put(PaymentTopUpController());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<PaymentTopUpController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarCommonWidget().build("payment_momo_title".tr, () {
        Modular.to.pop();
      }),
      backgroundColor: AppColors.whiteSmoke5,
      body: DeviceUtils.buildWidget(context, _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        Obx(
          () => Visibility(
            visible: !_topUpController.success.value,
            child: _buildMainContent(),
          ),
        ),
        Obx(
          () => Visibility(
            visible: _topUpController.success.value,
            child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              padding: EdgeInsets.all(18.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.green, size: 200.sp,),
                  Text('Yều cầu nạp tiền thành công',
                    style: TextStyle(
                      fontSize: 28.sp
                    ),
                  ),
                  SizedBox(height: 16.h,),
                  Text('Vui lòng xác nhận giao dịch trên Momo',
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                    ),),
                  SizedBox(height: 32.h,),
                  RoundedButtonGradientWidget(
                    buttonText: 'Đã xác nhận'.tr,
                    buttonColor: AppColors.pinkGradientButton,
                    textColor: Colors.white,
                    width: double.infinity,
                    height: 65.h,
                    onPressed: () => Modular.to.pop(),
                    textSize: 22.sp,
                  ),
                  SizedBox(height: 48.h,),
                ],
              ),
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: _topUpController.loading.value,
              child: CustomProgressIndicatorWidget(),
            )),
      ],
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: 15.h),
        child: Column(
          children: <Widget>[
            MoneyTopUpSelectorWidget(
                title: 'Momo',
                titleIcon: Image.asset(Assets.momoIcon),
                controller: _topUpController),
            Padding(
              padding: EdgeInsets.all(16.h),
              child: Column(
                children: [
                  Text(
                    'payment_note'.tr,
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  RoundedButtonGradientWidget(
                    buttonText: 'payment_pay_now'.tr,
                    buttonColor: AppColors.pinkGradientButton,
                    textColor: Colors.white,
                    width: double.infinity,
                    height: 60.h,
                    isEnabled: _topUpController.numMoney.value > 0,
                    onPressed: () async {
                      _topUpController.loading.value = true;
                      final either = await _topUpService.topUp(TopUpParamDto(
                          amount: _topUpController.numMoney.value,
                          method: 'MOMO'));
                      either.fold((l) => _topUpController.loading.value = false,
                          (res) async {
                        final data = MomoResponseDto.fromMap(res.data);
                        _topUpController.loading.value = false;
                        if (data.payUrl.isNotEmpty) {
                          _topUpController.success.value = true;
                          await launch(
                            data.payUrl,
                            forceSafariVC: false,
                            forceWebView: false,
                          );
                        }
                      });
                    },
                    textSize: 16.sp,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
