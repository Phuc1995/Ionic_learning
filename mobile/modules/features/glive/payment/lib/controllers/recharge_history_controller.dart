import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:payment/contants/contants.dart';
import 'package:payment/dto/dto.dart';
import 'package:payment/service/top_up_service.dart';

class RechargeHistoryController extends GetxController {
  final _topUpService = Modular.get<TopUpService>();
  final inputFormat = new DateFormat(Strings.DATE_FORMAT);
  var networks = <NetworkDto>[].obs;
  late String storageUrl;
  final int LIMIT = 10;
  var listData = <TopUpHistoryDto>[].obs;
  var currentPage = 1.obs;
  var totalPage = 1.obs;
  var unreadNotification = 0.obs;
  var isLoading = false.obs;

  //history filter
  DateTime? nowDate = DateTime.now();
  var listNetworkFilter = [PaymentContants.ALL].obs;
  var listAssetFilter = [PaymentContants.ALL].obs;
  var dropdownValueNetwork = PaymentContants.ALL.obs;
  var dropdownValueAsset = PaymentContants.ALL.obs;
  var statusFilter = PaymentContants.ALL.obs;
  var currentNetwork = -1.obs;
  var startDayFilter = "".obs;
  var endDayFilter = "".obs;
  var tmpTime = DateTime.now().obs;
  var isNoNetwork = false.obs;

  RechargeHistoryController();

  @override
  void onInit() {
    super.onInit();
    DateTime? nowDate = DateTime.now();
    DateTime? date = new DateTime(nowDate.year, nowDate.month, nowDate.day - 7);
    this.tmpTime.value = date;
    this.startDayFilter.value = inputFormat.format(date);
    this.endDayFilter.value = inputFormat.format( new DateTime(nowDate.year, nowDate.month, nowDate.day));
  }

  Future<void> getData() async {
        this.isLoading.value = true;
        this.isNoNetwork.value = false;
        var data = await _topUpService.getHistory(TopUpHistoryParamDto(
          page: this.currentPage.value,
          limit: this.LIMIT,
          status: this.statusFilter.value == PaymentContants.ALL ? null: this.statusFilter.value,
          network: currentNetwork < 0 ? null : this.currentNetwork,
          tokenType: this.dropdownValueAsset.value == PaymentContants.ALL ? null : this.dropdownValueAsset.value,
          transactionDate: [this.startDayFilter.value, this.endDayFilter.value],
        ));
        data.fold((failure) {
          this.isNoNetwork.value = true;
          this.isLoading.value = false;
        }, (data) {{
          this.listData.addAll(data[PaymentContants.ITEM]);
          this.totalPage.value = data[PaymentContants.TOTAL_PAGE];
          this.listData.refresh();
          this.isLoading.value = false;
          this.isNoNetwork.value = false;
        }
        });
  }

  Future<void> getNetworks() async {
    final network = await _topUpService.getNetwork();
    network.fold((l) => null, (data) {
      this.networks.value = data;
    });
    networks.forEach((value){
      this.listNetworkFilter.add(value.name!);
    });
  }

  void addItemRechargeHistory(dynamic decode){
    TopUpHistoryDto entity = TopUpHistoryDto.fromSocketMap(decode);
    this.listData.insert(0, entity);
    this.listData.refresh();
  }

  void resetAllController(){
    this.listData.clear();
    this.currentPage.value = 1;
    this.totalPage.value = 1;
    this.isLoading.value = false;
    statusFilter.value = PaymentContants.ALL;
  }

  void resetFilter(){
    this.listAssetFilter.clear();
    this.currentPage.value = 1;
    this.listAssetFilter.add(PaymentContants.ALL);
    this.dropdownValueNetwork.value = PaymentContants.ALL;
    this.dropdownValueAsset.value = PaymentContants.ALL;
    this.statusFilter.value = PaymentContants.ALL;
    DateTime? date = new DateTime(nowDate!.year, nowDate!.month, nowDate!.day-7);
    this.tmpTime.value = date;
    this.startDayFilter.value = inputFormat.format(date);
    this.endDayFilter.value = inputFormat.format( new DateTime(nowDate!.year, nowDate!.month, nowDate!.day));
    this.currentNetwork = -1;
  }
}
