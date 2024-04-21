import 'package:common_module/common_module.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_stream/presentation/controller/camera/camera_handle_controller.dart';

class EndLiveButton extends StatelessWidget {

  final Function? onCancel;

  final Function? onConfirm;

  final CameraLiveController? cameraLiveController;

  const EndLiveButton({
    Key? key,
    this.onCancel,
    this.onConfirm,
    this.cameraLiveController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: IconButton(
        color: Colors.white70,
        icon: new Icon(Icons.close),
        iconSize: 32.sp,
        onPressed: () => {
          onConfirm!()
        },
      ),
    );
  }

}