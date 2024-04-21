import 'dart:collection';
import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:payment/dto/dto.dart';
import 'package:payment/service/transaction_history_service.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';

class TransactionHistoryController extends GetxController{
  late SharedPreferenceHelper _sharedPrefsHelper;

  var listItemFilter =  SplayTreeMap<int, String>().obs;
  var listWidgetItemHistory = <Widget>[].obs;
  var listItemHistory = <ItemTransactionHistoryDto>[].obs;

  var isLoading = false.obs;
  var currentItemFiltter = 0.obs;
  var fromDate = ''.obs;
  var toDate = ''.obs;
  var totalPage = 1.obs;
  var pageCurrent = 1.obs;

  TransactionHistoryController();

  @override
  void onInit() {
    super.onInit();
    SharedPreferenceHelper.getInstance().then((value) => _sharedPrefsHelper = value);
  }

}