import 'package:get/get.dart';
import 'package:user_management/constants/report_filter_type.dart';

class ReportController extends GetxController {
  ReportController();

  var time_report = ''.obs;
  var detailLength = 0.obs;
  var typeSelect = ReportFilterType.RECHARGE.obs;

  changeType(String type) {
    typeSelect.value = type;
  }

}