import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payment/dto/dto.dart';

class TransactionHistoryController extends GetxController {

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
  }
}
