import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterButton extends StatelessWidget {
  final UserStoreController userStoreController;

  const RegisterButton({Key? key, required this.userStoreController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShowErrorMessage _showErrorMessage = ShowErrorMessage();

    return Obx(() => RoundedButtonGradientWidget(
        height: 60.h,
        textSize: 16.sp,
        buttonText: ('register_btn_register').tr,
        buttonColor: userStoreController.isEnabledSubmitRegisterBtn.value
            ? AppColors.pinkGradientButton
            : LinearGradient(
                colors: [
                  Color(0xFF8A8A8A),
                  Color(0xFF8A8A8A),
                ],
                begin: Alignment(-1, 0.7),
                end: Alignment(1, -0.7),
              ),
        textColor: Colors.white,
        isEnabled: userStoreController.isEnabledSubmitRegisterBtn.value,
        onPressed: () async {
          DeviceUtils.hideKeyboard(context);
              userStoreController.otpType.value = 'email';
              userStoreController.isLoading.value = true;
              final verifyOtp = await userStoreController.verifyOtp();
              _handleRegister(verifyOtp, context, _showErrorMessage);
        }
        ));
  }

  _handleRegister(
      Either<Failure, bool> verifyOtp, BuildContext context, ShowErrorMessage showErrorMessage) {
    verifyOtp.fold((failure) {
      userStoreController.isLoading.value = false;
      String errorMessage = ('register_error_message').tr;
      if (failure is DioFailure && failure.messageCode == MessageCode.INCORRECT_OTP) {
        errorMessage = ('register_incorrect_otp').tr;
      }
      showErrorMessage.show(context: context, message: errorMessage);
    }, (isSuccess) async {
      DeviceUtils.hideKeyboard(context);
      userStoreController.isLoading.value = false;
      if (isSuccess) {
        final register = await userStoreController.register();
        register.fold(
            (failure) =>
                showErrorMessage.show(context: context, message: ('register_error_unknown').tr),
            (isSuccess) {
          Modular.to.pushNamed(IdolRoutes.user_management.accountComplete);
        });
      } else {
        showErrorMessage.show(context: context, message: ('register_error_unknown').tr);
      }
    });
  }
}
