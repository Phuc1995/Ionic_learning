import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:payment/contants/filter_type.dart';
import 'package:payment/dto/dto.dart';
import 'package:payment/service/transaction_history_service.dart';

class StatisticController extends GetxController {
  late SharedPreferenceHelper _sharedPrefsHelper;
  final _transactionHistoryService = Modular.get<TransactionHistoryService>();
  var typeSelect = FilterType.day.obs;
  var fromDate = DateFormat('dd-MM-yyyy')
      .format(DateTime.now().add(Duration(days: -7)))
      .obs;
  var toDate = DateFormat('dd-MM-yyyy')
      .format(DateTime.now())
      .obs;
  var listItemStatistic = <ItemStatisticDto>[].obs;
  var summaryObject = SummaryDto(
      totalDate: 0, totalFan: 0, totalLiveTime: 0, totalRuby: 0).obs;

  var currentPage = 1.obs;
  var totalPage = 1.obs;

  var isLoading = false.obs;

  StatisticController();

  @override
  void onInit() {
    super.onInit();
    SharedPreferenceHelper.getInstance().then((value) =>
    _sharedPrefsHelper = value);
  }

  getDataStatistic() async {
    var data = await _transactionHistoryService.getStatistic(
        ItemStatisticParamDto(page: currentPage.value, type: typeSelect.value,
            fromDate: this.fromDate.value, toDate: this.toDate.value));
    data.fold((l) => isLoading.value = false, (data) {
      {
        listItemStatistic.addAll(data.getItems()!);
        totalPage.value = data.page!.totalPages;
        summaryObject.value = data.getSummary()!;
        isLoading.value = false;
      }
    });
  }

  resetFilterController() {
    currentPage = 1.obs;
    totalPage = 1.obs;
    isLoading = false.obs;
    listItemStatistic.value = [];
  }

  changeTypeCalendar(String type) {
    final nowDate = DateTime.now();
    typeSelect.value = type;
    switch (type) {
      case FilterType.day:
        fromDate.value =
            DateFormat('dd-MM-yyyy').format(nowDate.add(Duration(days: -7)));
        toDate.value = DateFormat('dd-MM-yyyy').format(nowDate);
        break;
      case FilterType.week:
        fromDate.value = getDate(
            nowDate.subtract(Duration(days: (nowDate.weekday - 1) + 49)));
        toDate.value = getDate(nowDate.add(
            Duration(days: DateTime.daysPerWeek - nowDate.weekday)));
        break;
      default:
        fromDate.value =
            DateFormat('dd-MM-yyyy').format(
                DateTime.utc(nowDate.year, nowDate.month, 1));
        toDate.value = DateFormat('dd-MM-yyyy').format(DateTime.utc(
          nowDate.year,
          nowDate.month + 1,
        ).subtract(Duration(days: 1)));
        break;
    }
  }

  String getDate(DateTime d) {
    return DateFormat('dd-MM-yyyy').format(DateTime(d.year, d.month, d.day));
  }

  String showFilter() {
    if (this.typeSelect.value == FilterType.month) {
      return (DateFormat('MM-yyyy')
          .format(DateFormat("dd-MM-yyyy").parse(this.fromDate.value)) +
          '  -  ' +
          DateFormat('MM-yyyy')
              .format(DateFormat("dd-MM-yyyy").parse(this.toDate.value)));
    } else {
      return this.fromDate.value + '  -  ' + this.toDate.value;
    }
  }

  String convertType(String type) {
    String result = '';
    switch (type) {
      case FilterType.day:
        result = "payment_statistic_day".tr;
        break;
      case FilterType.week:
        result = "payment_statistic_week".tr;
        break;
      case FilterType.month:
        result = "payment_statistic_month".tr;
        break;
    }
    return result;
  }

  void onPressed(String type) {
    this.changeTypeCalendar(type);
    this.resetFilterController();
    this.getDataStatistic();
  }
}