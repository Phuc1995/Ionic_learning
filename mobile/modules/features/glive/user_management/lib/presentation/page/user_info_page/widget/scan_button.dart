import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/controllers/user_store_controller.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserStoreController _userStoreController = Get.put(UserStoreController());
    return IconButton(
      onPressed: () async {
        await _userStoreController.removeDeviceInfo();
        },
      icon: Icon(
        CustomIcons.qrcode,
        color: Colors.white,
        size: 26.sp,
      ),
    );
  }
}
