import 'package:another_flushbar/flushbar.dart';
import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/presentation/page/user_info_edit_page/edit_intro_page.dart';

class ShowErrorMessage  {
  UserStoreController userStoreController = Get.put(UserStoreController());

  Widget show({required BuildContext context, required String message}){
    if (message.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 0), () {
        if (message.isNotEmpty) {
          Flushbar(
            shouldIconPulse: false,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
            icon: Container(
              child: Align(
                alignment: Alignment.centerRight,
                  child: Icon(Icons.warning, color: AppColors.pinkLiveButtonCustom, size: 18.sp,)),
            ),
            backgroundColor: ConvertCommon().hexToColor("#F6F6F6"),
            messageText: Align(
                alignment: Alignment.centerLeft,
                child: Text(message, style: TextUtils.textStyle(FontWeight.w500, 14.sp, color: ConvertCommon().hexToColor("#DD2863")),)),
            duration: Duration(seconds: 3),
          )..show(context);
          userStoreController.errorMessage.value = '';
        }
      });
    }
    return SizedBox.shrink();
  }

}
