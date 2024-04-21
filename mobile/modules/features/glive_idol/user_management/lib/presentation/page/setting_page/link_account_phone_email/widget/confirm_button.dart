import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/domain/usecase/auth/link_account.dart';
import 'package:user_management/presentation/controller/user/link_account_store_controller.dart';
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
            LinkAccountParams params = new LinkAccountParams(
              isPhone: false,
              email: storeController.emailController.value,
              verifyCode: storeController.verifyController.value
            );
            if (storeController.isPhone.value) {
              params = new LinkAccountParams(
                  isPhone: true,
                  phoneCode: storeController.phoneCodeController.value,
                  phoneNumber: storeController.phoneController.value,
                  verifyCode: storeController.verifyController.value
              );
            }
            final res = await LinkAccount().call(params);
            _handleLinkAccount(res, context);
            storeController.isLoading.value = false;
          }),
    );
  }

  _handleLinkAccount(Either<Failure, GatewayResponse> result, BuildContext context) {
    ShowErrorMessage showErrorMessage = ShowErrorMessage();
    result.fold((failure) {
      String errorMessage = 'link_account_error_unknown'.tr;
      if (failure is DioFailure) {
        if (failure.messageCode == MessageCode.INCORRECT_OTP) {
          errorMessage = 'link_account_incorrect_otp'.tr;
        } else if (failure.messageCode == MessageCode.LINK_ACCOUNT_EXISTING) {
          errorMessage = this.storeController.isPhone.value ? 'link_account_existed_phone'.tr : 'link_account_existed_email'.tr;
        }
      }
      showErrorMessage.show(
        message: errorMessage,
        context: context,
      );
    }, (res) {
      if (res.messageCode == MessageCode.LINK_ACCOUNT_SUCCESS) {
        DeviceUtils.hideKeyboard(context);
        Modular.to.pop({
          'isConfirm': true,
        });
      } else {
        showErrorMessage.show(
          message: 'link_account_error_unknown'.tr,
          context: context,
        );
      }
    });
  }
}
