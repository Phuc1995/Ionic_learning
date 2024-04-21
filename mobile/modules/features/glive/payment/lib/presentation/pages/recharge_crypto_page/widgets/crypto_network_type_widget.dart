import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment/controllers/recharge_crypto_controller.dart';

class CryptoNetworkTypeWidget extends StatelessWidget {
  const CryptoNetworkTypeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RechargeCryptoController _rechargeController = Get.put(RechargeCryptoController());
    late SharedPreferenceHelper _sharedPrefsHelper = Modular.get<SharedPreferenceHelper>();
    late final String storageUrl = _sharedPrefsHelper.storageServer + '/' + _sharedPrefsHelper.bucketName + '/';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "payment_crypto_tabview_network_type".tr,
          style: TextUtils.textStyle(FontWeight.w400, 15.sp,
              color: AppColors.suvaGrey),
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          child: Obx(() => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 185.w / 70.h,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 15.w),
                itemCount: _rechargeController.tokens.length.isEven ? _rechargeController.tokens.length : _rechargeController.tokens.length +1 ,
                semanticChildCount: 20,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return _buildItemWidget(context, index, _rechargeController, storageUrl);
                },
              )),
        ),
      ],
    );
  }

  Widget _buildItemWidget(BuildContext context, int index, RechargeCryptoController rechargeController, String storageUrl ) {
    return index < rechargeController.tokens.length ? InkWell(
      onTap: (){
          rechargeController.currentToken.value = rechargeController.tokens[index];
          rechargeController.setCurrentNetwork(rechargeController.currentToken.value.networkId.toString());
      },
      child: Obx(() => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: rechargeController.currentToken.value == rechargeController.tokens[index] ? AppColors.pink3 :  AppColors.whiteSmoke4,
                ),
                color: rechargeController.currentToken.value == rechargeController.tokens[index] ? Colors.white : AppColors.whiteSmoke4.withOpacity(0.25),
                borderRadius: BorderRadius.all(Radius.circular(5.r)) ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 10.w, right: 7.w, top: 5.h),
                    child: CachedNetworkImage(
                      imageUrl: storageUrl + rechargeController.tokens[index].logoUri.toString(),
                    ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(rechargeController.tokens[index].symbol!,
                          style: TextUtils.textStyle(FontWeight.w600, 14.sp,
                              color: AppColors.grayCustom2)),
                      Text(rechargeController.tokens[index].type,
                          style: TextUtils.textStyle(FontWeight.w500, 13.sp,
                              color: AppColors.grey3))
                    ],
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: rechargeController.currentToken.value == rechargeController.tokens[index],
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
      )),
    ) : Container( decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.whiteSmoke4,
        ),
        color: AppColors.grey5,
        borderRadius: BorderRadius.all(Radius.circular(5.r))));
  }
}
