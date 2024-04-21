import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rtmp_publisher/camera.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';

class CameraLiveController extends GetxController {
  // constructor:---------------------------------------------------------------
  CameraLiveController();

  var description = CameraDescription().obs;
  var isLive = false.obs;
  var streamId = ''.obs;
  var isThumbnailCamera = false.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  void resetController(){
    isThumbnailCamera.value = false;
    isLive.value = false;
  }

  CameraDescription switchCamera(CameraDescription cameraDescription, List<CameraDescription> cameras){
    final lensDirection = cameraDescription.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = cameras
          .firstWhere((description) => description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = cameras
          .firstWhere((description) => description.lensDirection == CameraLensDirection.front);
    }
    return newDescription;
  }



  Future<void> stopVideoStreaming(CameraController? cameraController, BuildContext context) async {
    if (!(cameraController!.value.isStreamingVideoRtmp??false)) {
      return null;
    }

    try {
      await cameraController.stopVideoStreaming();
    } on CameraException catch (e) {
      ShowErrorMessage().show(context: context, message: e.toString());
      return null;
    }
  }


}
