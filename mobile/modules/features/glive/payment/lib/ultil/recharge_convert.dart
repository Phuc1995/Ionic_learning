import 'package:common_module/utils/convert/convert_common.dart';
import 'package:get/get.dart';
import 'package:payment/contants/contants.dart';

class RechargeConvert{

  String convertTitleStatus(String str){
    String result = '';
    switch(str){
      case PaymentContants.ALL:
        result = "payment_transaction_filter_all".tr;
        break;
      case PaymentContants.PROCESSING:
        result = "payment_history_status_processing".tr;
        break;
      case PaymentContants.COMPLETED:
        result = "payment_history_status_complete".tr;
        break;
      case PaymentContants.FAILED:
        result = "payment_history_status_fail".tr;
        break;
    }
    return result;
  }

  String convertRechargeInfoCancelButton(String status){
    String result = 'payment_crypto_info_cancel_button'.tr;
    if(status.toUpperCase() == StatusType.FAILED.name || status.toUpperCase() == StatusType.COMPLETED.name ){
      result = "payment_crypto_info_completed_button".tr;
    }
    return result;
  }
}