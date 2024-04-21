import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:payment/contants/filter_type.dart';
import 'package:payment/dto/dto.dart';
import 'package:payment/services/services.dart';

class StatisticController extends GetxController {

  var typeSelect = FilterType.day.obs;
  var fromDate = DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(days: -7))).obs;
  var toDate = DateFormat('dd-MM-yyyy').format(DateTime.now()).obs;
  var listItemStatistic = <ItemStatisticDto>[].obs;
  var summaryObject = SummaryDto(totalDate: 0, totalFan: 0, totalLiveTime: 0, totalRuby: 0).obs;

  var currentPage = 1.obs;
  var totalPage = 1.obs;

  var isNoNetwork = false.obs;
  var isLoading = false.obs;

  StatisticController();

  @override
  void onInit() {
    super.onInit();
  }

  Future getDataStatistic(BuildContext context) async {
    final transactionHistoryService = Modular.get<TransactionHistoryService>();
    var data = await transactionHistoryService.getStatistic(StatisticParamDto(page: this.currentPage.value, type: this.typeSelect.value,
        fromDate: this.fromDate.value, toDate: this.toDate.value));
    data.fold((failure) {
      this.isNoNetwork.value = true;
      this.isLoading.value = false;
    }, (data) {
      this.listItemStatistic.addAll(data.getItems()!);
      this.totalPage.value = data.getPageData()!.totalPages;
      this.summaryObject.value = data.getSummary()!;
      this.isLoading.value = false;
      this.isNoNetwork.value = false;
    });
  }

  void resetFilterController(){
    this.currentPage = 1.obs;
    this.totalPage = 1.obs;
    this.isLoading = false.obs;
    this.listItemStatistic.value = [];
  }

  void changeTypeCalendar(String type) {
    final nowDate = DateTime.now();
    this.typeSelect.value = type;
    switch (type) {
      case FilterType.day:
        this.fromDate.value = DateFormat('dd-MM-yyyy').format(nowDate.add(Duration(days: -7)));
        this.toDate.value = DateFormat('dd-MM-yyyy').format(nowDate);
        break;
      case FilterType.week:
        this.fromDate.value = getDate(nowDate.subtract(Duration(days: (nowDate.weekday - 1) + 49)));
        this.toDate.value = getDate(nowDate.add(Duration(days: DateTime.daysPerWeek - nowDate.weekday)));
        break;
      default:
        this.fromDate.value =
            DateFormat('dd-MM-yyyy').format(DateTime.utc(nowDate.year, nowDate.month, 1));
        this.toDate.value = DateFormat('dd-MM-yyyy').format(DateTime.utc(
          nowDate.year,
          nowDate.month + 1,
        ).subtract(Duration(days: 1)));
        break;
    }
  }

  String getDate(DateTime d) {
    return DateFormat('dd-MM-yyyy').format(DateTime(d.year, d.month, d.day));
  }
}
