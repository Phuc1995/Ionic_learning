import 'dart:ui';

import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numeral/numeral.dart';

enum StatusType {
  COMPLETED,
  FAILED,
  NEW,
  PROCESSING,
  MANUAL_WAITING_RECHARGE
}

class ConvertCommon {
  static const String All = "All";
  static const String DEPOSIT = "DEPOSIT";
  static const String WITHDRAW = "WITHDRAW";
  static const String BUY_GIFT = "BUY_GIFT";
  static const String RECEIVE_GIFT = "RECEIVE_GIFT";
  static const String DATE_FORMAT = "HH:mm:ss dd/MM/yyyy";

  final balanceFormat = new NumberFormat("#,###", 'eu');

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  String tyeTransactionTranslate(String typeFromServer){
    String typeDescription = "";
    switch (typeFromServer){
      case All:
        typeDescription = "payment_transaction_filter_all";
        break;
      case DEPOSIT:
        typeDescription = "payment_transaction_filter_deposit";
        break;
      case WITHDRAW:
        typeDescription = "payment_transaction_filter_withdraw";
        break;
      case BUY_GIFT:
        typeDescription = "payment_transaction_filter_buy_gift";
        break;
      case RECEIVE_GIFT:
        typeDescription = "payment_transaction_filter_receive_gift";
        break;
      default:
        typeDescription = "payment_transaction_filter_message_error";
    }
    return typeDescription;
  }

  String formatSecondDuration(int seconds) {
    var d = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String convertDate(String dateServer) {
    var parsedDate = DateTime.parse(dateServer);
    return DateFormat(DATE_FORMAT).format(parsedDate.toLocal()).replaceAll(" ", " - ");
  }

  String convertStatus(String status){
    String result = '';
    if(status.toUpperCase() == StatusType.COMPLETED.name){
      result = "payment_history_status_complete".tr;
    } else if(status.toUpperCase() == StatusType.FAILED.name){
      result = "payment_history_status_fail".tr;
    } else if(status.toUpperCase() == StatusType.PROCESSING.name){
      result = "payment_history_status_processing".tr;
    }
    return result;
  }

  String convertRechargeCache(String status){
    String result = '';
    if(status.toUpperCase() == StatusType.MANUAL_WAITING_RECHARGE.name){
      result = "payment_crypto_cache_waiting".tr;
    } else if(status.toUpperCase() == StatusType.NEW.name){
      result = "payment_crypto_cache_new".tr;
    } else if(status.toUpperCase() == StatusType.PROCESSING.name){
      result = "payment_history_status_processing".tr;
    }
    return result;
  }

  Color convertStatusColors(String status){
    Color color = AppColors.mountainMeadow3;
    if(status.toUpperCase() == StatusType.COMPLETED.name){
      color = AppColors.mountainMeadow3;
    } else if(status.toUpperCase() == StatusType.FAILED.name){
      color = AppColors.mahogany;
    } else if(status.toUpperCase() == StatusType.PROCESSING.name){
      color = AppColors.sunglow;
    } else if(status.toUpperCase() == StatusType.MANUAL_WAITING_RECHARGE.name){
      color = AppColors.sunglow;
    }
    return color;
  }

  Widget convertWidgetStatus(String status){
    Widget result = Container();
    if(status.toUpperCase() == StatusType.COMPLETED.name){
      result = Container(
        width: 20,
        height: 20,
        child: CircleAvatar(
            backgroundColor: AppColors.mountainMeadow3,
            child: Icon(Icons.check, color: Colors.white, size: 14.sp,)),
      );
    } else if(status.toUpperCase() == StatusType.FAILED.name){
      result = Container(
        width: 20,
        height: 20,
        child: Icon(Icons.cancel, color: AppColors.mahogany, size: 20.sp,),
      );
    } else if(status.toUpperCase() == StatusType.PROCESSING.name){
      result = Container(
        width: 15,
        height: 15,
        color: Colors.white,
        child: CircularProgressIndicator(backgroundColor: Colors.white, color: AppColors.sunglow2, ),
      );
    }
    return result;
  }

  String convertBalance(String str){
    int? number = int.tryParse(str);
    return balanceFormat.format(number);
  }

  String convertViewCount(String str){
    int? number = int.tryParse(str)??0;
    return Numeral(number).format(fractionDigits: 1);
  }

}