import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/controllers/user_store_controller.dart';

class ButtonSupportWidget extends StatelessWidget {
  const ButtonSupportWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late SharedPreferenceHelper _sharedPrefsHelper = Modular.get<SharedPreferenceHelper>();
    UserStoreController _userStoreController = Get.put(UserStoreController());
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h,),
          Text("payment_crypto_support_button_title".tr, style: TextUtils.textStyle(FontWeight.w400, 15.sp, color: AppColors.pink2),),
          SizedBox(height: 20.h,),
          RoundedButtonGradientWidget(
            buttonText: 'payment_crypto_support_button_content'.tr,
            buttonColor: AppColors.pinkGradientButton,
            textColor: Colors.white,
            width: double.infinity,
            height: 50.h,
            onPressed: () {
              Modular.to.pushNamed(ViewerRoutes.support, arguments: { 'profile': _userStoreController.profile.value,
              });
              // Livechat.beginChat(dotenv.env['LIVE_CHAT_LICENSE_NO']!, dotenv.env['LIVE_CHAT_GROUP']!, _sharedPrefsHelper.getUserNameSupport!, _sharedPrefsHelper.getUserMailSupport!);
            },
            textSize: 16.sp,
          )
        ],
      ),
    );
  }

}
