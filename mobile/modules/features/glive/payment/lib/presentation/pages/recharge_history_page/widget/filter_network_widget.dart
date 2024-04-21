import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:payment/contants/contants.dart';
import 'package:payment/controllers/recharge_history_controller.dart';

class FilterNetworkWidget extends StatefulWidget {
  const FilterNetworkWidget({Key? key}) : super(key: key);

  @override
  State<FilterNetworkWidget> createState() => _FilterNetworkWidgetState();
}

class _FilterNetworkWidgetState extends State<FilterNetworkWidget> {
  RechargeHistoryController _historyController = Get.put(RechargeHistoryController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 27.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("payment_crypto_network".tr, style: TextUtils.textStyle(FontWeight.w500, 14.sp, color: AppColors.grayCustom2),),
          SizedBox(height: 12.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _createItemNetwork(),
            ],
          ),
          SizedBox(height: 12.h,),
          Text("payment_history_asset".tr, style: TextUtils.textStyle(FontWeight.w500, 14.sp, color: AppColors.grayCustom2),),
          SizedBox(height: 12.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _createItemAsset(),
            ],
          ),
          SizedBox(height: 20.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundedButtonGradientWidget(
                  height: 36.h,
                  width: 168.w,
                  textSize: 16.sp,
                  buttonText: 'payment_history_filter_reset_button'.tr,
                  buttonColor: AppColors.darkGradientBackground,
                  textColor: Colors.white,
                  onPressed: () async {
                    _historyController.resetFilter();
                  }
              ),
              RoundedButtonGradientWidget(
                  height: 36.h,
                  width: 168.w,
                  textSize: 16.sp,
                  buttonText: 'payment_history_filter_confirm_button'.tr,
                  buttonColor: AppColors.pinkGradientButton,
                  textColor: Colors.white,
                  onPressed: () async {
                    _historyController.listData.clear();
                    _historyController.getData();
                    Modular.to.pop();
                  }
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _createItemNetwork(){
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
            color: AppColors.grey4
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.r),
        ),
      ),
      width: 350.w,
      child: Padding(
        padding: EdgeInsets.only(left: 15.w),
        child: Obx(() => DropdownButton<String>(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          value: _historyController.dropdownValueNetwork.value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          style: TextUtils.textStyle(FontWeight.w400, 14.sp, color: AppColors.grey3),
          underline: Container(
            height: 0,
          ),
          onChanged: (String? newValue) {
            if(newValue != _historyController.dropdownValueNetwork.value){
              _historyController.listAssetFilter.clear();
              _historyController.listAssetFilter.add(PaymentContants.ALL);
              _historyController.dropdownValueAsset.value = PaymentContants.ALL;
              _historyController.dropdownValueNetwork.value = newValue!;
              if(newValue != PaymentContants.ALL){
                int index = _historyController.networks.indexWhere((item) => item.name == _historyController.dropdownValueNetwork.value);
                _historyController.currentNetwork = _historyController.networks[index].id;
                _historyController.networks[index].exchangeRates!.forEach((element) {
                  _historyController.listAssetFilter.add(element.symbol!);
                });
              } else {
                _historyController.currentNetwork = -1;
              }
            }
          },
          items: _historyController.listNetworkFilter.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )),
      ),
    );
  }

  Widget _createItemAsset(){
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
            color: AppColors.grey4
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.r),
        ),
      ),
      width: 350.w,
      child: Padding(
        padding: EdgeInsets.only(left: 15.w),
        child: Obx(() => DropdownButton<String>(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          value: _historyController.dropdownValueAsset.value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          style: TextUtils.textStyle(FontWeight.w400, 14.sp, color: AppColors.grey3),
          underline: Container(
            height: 0,
          ),
          onChanged: (String? newValue) {
            _historyController.dropdownValueAsset.value = newValue!;
          },
          items: _historyController.listAssetFilter.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )),
      ),
    );
  }
}
