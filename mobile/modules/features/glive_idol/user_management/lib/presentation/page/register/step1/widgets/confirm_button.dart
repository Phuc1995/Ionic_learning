import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/domain/usecase/auth/check_existing_user.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmButtonRegister extends StatelessWidget {
  final UserStoreController userStoreController;
  const ConfirmButtonRegister({Key? key, required this.userStoreController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShowErrorMessage showErrorMessage = ShowErrorMessage();
    return Obx(() => RoundedButtonGradientWidget(
        height: 60.h,
        textSize: 16.sp,
        buttonText: ('register_btn_confirm').tr,
        buttonColor: userStoreController.isEnabledStep1Button.value
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
        isEnabled: userStoreController.isEnabledStep1Button.value,
        onPressed: () async {
              if (this.userStoreController.isInvalidInputFields(context)) {
                return;
              }
              userStoreController.isLoading.value = true;
              CheckExistingUserParams params = CheckExistingUserParams(
                loginWithPhone: userStoreController.loginWithPhone.value,
                phoneCode: userStoreController.phoneCodeController.value,
                phone: userStoreController.phoneController.value,
                email: userStoreController.emailController.value,
              );
              final isExisted = await CheckExistingUser().call(params);
              isExisted.fold((failure) {
                userStoreController.isLoading.value = false;
                if(failure is DioFailure && failure.message == "email must be an email"){
                  showErrorMessage.show(context: context, message: "forgot_password_invalid_email".tr);
                } else if(failure is NetworkFailure){
                  ShowShortMessage().showTop(context: context, message: "no_network".tr);
                } else {
                  showErrorMessage.show(context: context, message: "register_error_unknown".tr);
                }
              }, (isExit) {
                userStoreController.isLoading.value = false;
                DeviceUtils.hideKeyboard(context);
                if(isExit){
                  showErrorMessage.show(context: context, message: userStoreController.loginWithPhone.value ? 'register_existed_phone'.tr : "register_existed_email".tr);
                } else {
                  userStoreController.isEnabledSubmitRegisterBtn.value = false;
                  Modular.to.pushNamed(IdolRoutes.user_management.registerStep2);
                }
              });
        }));
  }
}
