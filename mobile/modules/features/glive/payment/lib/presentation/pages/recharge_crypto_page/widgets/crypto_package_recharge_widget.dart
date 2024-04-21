import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment/contants/assets.dart';
import 'package:payment/controllers/recharge_crypto_controller.dart';

class CryptoPackageRechargeWidget extends StatelessWidget {
  const CryptoPackageRechargeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RechargeCryptoController _rechargeController = Get.put(RechargeCryptoController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "payment_crypto_amount".tr,
          style: TextUtils.textStyle(FontWeight.w400, 15.sp,
              color: AppColors.suvaGrey),
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          child: Obx(() => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 40.w / 16.h,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 15.w),
                itemCount: _rechargeController.packageAmount.length,
                semanticChildCount: 20,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return _buildItemWidget(context, index, _rechargeController);
                },
              )),
        ),
        SizedBox(
          height: 15.h,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(left: 0.w, bottom: 2.h),
            child: Obx(() => RichText(
                  text: TextSpan(
                    text: 'payment_pay_now'.tr,
                    style: TextUtils.textStyle(FontWeight.w400, 15.sp,
                        color: AppColors.suvaGrey),
                    children: <TextSpan>[
                      _rechargeController.currentToken.value.symbol == null
                          ? TextSpan(
                              text: " " +
                                  _rechargeController.packageSelect.value
                                      .toString() +
                                  " ",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                                color: AppColors.pink1,
                              ),
                            )
                          : TextSpan(
                              text: " " +
                                  _rechargeController.packageSelect.value
                                      .toString() +
                                  " " +
                                  _rechargeController.currentToken.value.symbol
                                      .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                                color: AppColors.pink1,
                              ),
                            ),
                      TextSpan(
                        text: 'payment_crypto_your_get'.tr,
                        style: TextUtils.textStyle(FontWeight.w400, 15.sp,
                            color: AppColors.suvaGrey),
                      ),
                      TextSpan(
                        text:
                            ' ${_rechargeController.packageSelect.value * 10} ' +
                                "live_ruby".tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          color: AppColors.pink1,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                )),
          ),
        ),
      ],
    );
  }

  Widget _buildItemWidget(BuildContext context, int index,
      RechargeCryptoController rechargeController) {
    return Obx(() => InkWell(
          onTap: () {
            rechargeController.packageSelect.value =
                rechargeController.packageAmount[index];
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: rechargeController.packageSelect.value ==
                              rechargeController.packageAmount[index]
                          ? AppColors.pink3
                          : AppColors.whiteSmoke4,
                    ),
                    color: rechargeController.packageSelect.value ==
                            rechargeController.packageAmount[index]
                        ? Colors.white
                        : AppColors.whiteSmoke4.withOpacity(0.25),
                    borderRadius: BorderRadius.all(Radius.circular(5.r))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 3.w),
                          height: 13.h,
                          child: Image.asset(
                            Assets.diamondIcon,
                          ),
                        ),
                        Text(
                          '${rechargeController.packageAmount[index] * 10}',
                          style: TextUtils.textStyle(FontWeight.w500, 16.sp),
                        ),
                      ],
                    ),
                    Text(
                      '${rechargeController.packageAmount[index]}' +
                          ' ${rechargeController.currentToken.value.symbol}',
                      style: TextUtils.textStyle(FontWeight.w400, 13.sp,
                          color: AppColors.suvaGrey),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: rechargeController.packageSelect.value == rechargeController.packageAmount[index],
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.r), topRight: Radius.circular(5.r)),
                      color: AppColors.pink3,
                    ),
                    width: 20.w,
                    height: 16.h,
                    child: Center(
                      child: Icon(Icons.check_sharp, color: Colors.white, size: 15.sp, ),
                    ),

                  ),
                ),
              )
            ],
          ),
        ));
  }
}
