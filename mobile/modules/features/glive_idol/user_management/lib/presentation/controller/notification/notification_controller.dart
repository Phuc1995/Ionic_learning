import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/notification_filter_type.dart';
import 'package:user_management/domain/entity/notification/notification_data_entity.dart';
import 'package:user_management/domain/usecase/notification/count_unread_notification.dart';
import 'package:user_management/domain/usecase/notification/get_list_notification.dart';

class NotificationController extends GetxController {
  late SharedPreferenceHelper _sharedPrefsHelper;
  late String storageUrl;
  NotificationController();

  @override
  void onInit() {
    super.onInit();
    SharedPreferenceHelper.getInstance().then((value) => _sharedPrefsHelper = value);
  }

  var typeSelect = NotificationFilterType.ALL.obs;
  var listData = <NotificationDataEntity>[].obs;

  var currentPage = 1.obs;
  var totalPage = 1.obs;
  var unreadNotification = 0.obs;

  var isLoading = false.obs;
  var isGetData = false.obs;
  var isNoNetwork = false.obs;

  Future getData(BuildContext context) async{
        this.isNoNetwork.value = false;
        var data = await ListDataNotification().call(ListDataNotificationParam(page: currentPage.value, type: typeSelect.value, limit: 20));
        data.fold((l) {
          this.isNoNetwork.value = true;
          this.isLoading.value = false;
        }, (data) {{
          listData.addAll(data.getItems()!);
          totalPage.value = data.getPageData()!.totalPages;
          countUnreadNotification();
          this.isNoNetwork.value = false;
        }
        });
  }

  void countUnreadNotification(){
    CountUnreadNotification().call(NoParams()).then((value) {
      value.fold((l) => null, (number) => unreadNotification.value = number);
    });
  }

  resetAllController(){
    typeSelect.value = NotificationFilterType.ALL;
    listData.value = <NotificationDataEntity>[];

    currentPage.value = 1;
    totalPage.value = 1;

    isLoading.value = false;
    isGetData.value = false;
  }

  resetFilter(){
    currentPage.value = 1;
    totalPage.value = 1;
    isLoading.value = false;
    listData.value = <NotificationDataEntity>[];
  }

  changeType(String type) {
    typeSelect.value = type;
  }
}