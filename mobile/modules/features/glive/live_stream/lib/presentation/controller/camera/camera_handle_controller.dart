import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';

class CameraLiveController extends GetxController {
  // constructor:---------------------------------------------------------------
  CameraLiveController();

  var isLive = false.obs;
  var streamId = ''.obs;
  var isThumbnailCamera = false.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  void resetController() {
    isThumbnailCamera.value = false;
    isLive.value = false;
  }
}
