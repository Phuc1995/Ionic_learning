import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rtmp_publisher/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CameraPreviewWidget extends StatelessWidget {

  final CameraController cameraController;

  const CameraPreviewWidget({
    Key? key,
    required this.cameraController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!(cameraController.value.isInitialized??false)) {
      return Text(
        'No camera was chosen',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.sp,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      final size = MediaQuery.of(context).size;
      return Transform.scale(
        scale: cameraController.value.aspectRatio / size.aspectRatio,
        child: Center(
          child: AspectRatio(
            aspectRatio: cameraController.value.aspectRatio,
            child: CameraPreview(cameraController),
          ),
        ),
      );
    }

  }
}