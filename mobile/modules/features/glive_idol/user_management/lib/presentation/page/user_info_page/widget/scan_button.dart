import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/domain/usecase/auth/remove_device_info.dart';
class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final deviceInfo = await DeviceUtils.getDeviceId();
        RemoveDeviceInfo().call(RemoveInfoParams(deviceId: deviceInfo.deviceId));      },
      icon: Icon(
        CustomIcons.qrcode,
        color: Colors.white,
        size: 26.sp,
      ),
    );
  }
}