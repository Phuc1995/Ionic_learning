import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/controllers/user_store_controller.dart';

class UserInfoEditWidget {
  UserStoreController _userStoreController = Get.put(UserStoreController());

  Widget genderItem(int index, String title, BuildContext context, bool isLastItem){
    return InkWell(
      onTap: (){
        _userStoreController.updateViewerInfo(field: "gender", content: index);
        _userStoreController.editGender.value = title.tr;
        Modular.to.pop();
      },
      child: Container(
          margin: EdgeInsets.only(bottom: isLastItem ? 0 :25.h),
          width: double.infinity,
          child: Text(title.tr, style: TextUtils.textStyle(FontWeight.w500, 20.sp),)),
    );
  }

}