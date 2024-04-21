import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/link_account_store_controller.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmButton extends StatelessWidget {
  final LinkAccountStoreController storeController;
  const ConfirmButton({Key? key, required this.storeController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16.0),
      child: RoundedButtonGradientWidget(
          height: 48.h,
          textSize: 16.sp,
          buttonText: 'link_account_confirm'.tr,
          buttonColor: AppColors.pinkGradientButton,
          textColor: Colors.white,
          onPressed: () async {
            DeviceUtils.hideKeyboard(context);
            if (storeController.isInvalidInputFields(context) ||
                storeController.isVerifyInvalid(context)) {
              return;
            }
            storeController.isLoading.value = true;
            LinkAccountParamsDto params = new LinkAccountParamsDto(
              isPhone: false,
              email: storeController.emailController.value,
              verifyCode: storeController.verifyController.value
            );
            if (storeController.isPhone.value) {
              params = new LinkAccountParamsDto(
                  isPhone: true,
                  phoneCode: storeController.phoneCodeController.value,
                  phoneNumber: storeController.phoneController.value,
                  verifyCode: storeController.verifyController.value
              );
            }
            final res = await storeController.linkAccount(params);
            storeController.handleLinkAccount(res, context);
          }),
    );
  }


}
