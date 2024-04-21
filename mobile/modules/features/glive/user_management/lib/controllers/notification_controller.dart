import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/notification_filter_type.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/dto/notification_data_dto.dart';
import 'package:user_management/service/notification_service.dart';

class NotificationController extends GetxController {
  final _notificationService = Modular.get<NotificationService>();
  late SharedPreferenceHelper _sharedPrefsHelper;
  late String storageUrl;
  NotificationController();

  @override
  void onInit() {
    super.onInit();
    SharedPreferenceHelper.getInstance().then((value) => _sharedPrefsHelper = value);
  }

  final int LIMIT = 20;
  final String ITEMS = "items";
  final String TOTAL_PAGES = "totalPages";
  var typeSelect = NotificationFilterType.ALL.obs;
  var listData = <NotificationDataDto>[].obs;
  var currentPage = 1.obs;
  var totalPage = 1.obs;
  var unreadNotification = 0.obs;
  var isLoading = false.obs;
  var isGetData = false.obs;
  var isNoNetwork = false.obs;

  Future getData(BuildContext context) async {
        this.isLoading.value = true;
        var data = await _notificationService.getData(ListDataNotificationParamDto(page: this.currentPage.value, type: this.typeSelect.value, limit: this.LIMIT));
        data.fold((failure) {
         this.isNoNetwork.value = true;
         this.isLoading.value = false;
        }, (data) {{
          this.listData.addAll(data.getItems()!);
          this.totalPage.value = data.getPageData()!.totalPages;
          countUnreadNotification();
          this.isNoNetwork.value = false;
        }});
  }

  Future countUnreadNotification() async {
    _notificationService.countUnreadNotification().then((value) {
      value.fold((l) => null, (number) => this.unreadNotification.value = number);
    });
  }

  Future tickWasReadNotification({required int id, required bool read, required int index}) async {
    _notificationService.tickWasRead(TickWasReadNotificationParamDto(
      id: id,
      read: read,
    )).then((value) {
      value.fold((l) => null, (r) {
        this.listData[index].read = true;
        if(this.typeSelect.value == NotificationFilterType.UNREAD){
          this.listData.removeAt(index);
        }
        this.listData.refresh();
        this.unreadNotification.value = this.unreadNotification.value - 1;
      });
    });
  }


  resetAllController(){
    this.typeSelect.value = NotificationFilterType.ALL;
    this.listData.value = <NotificationDataDto>[];
    this.currentPage.value = 1;
    this.totalPage.value = 1;
    this.isLoading.value = false;
    this.isGetData.value = false;
  }

  resetFilter(){
    this.currentPage.value = 1;
    this.totalPage.value = 1;
    this.isLoading.value = false;
    this.listData.value = <NotificationDataDto>[];
  }

  changeType(String type) {
    this.typeSelect.value = type;
  }


}