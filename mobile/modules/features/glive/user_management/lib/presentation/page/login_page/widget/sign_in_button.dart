import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInButton extends StatelessWidget {
  final UserStoreController userStoreController;
  const SignInButton({Key? key, required this.userStoreController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShowErrorMessage showErrorMessage = ShowErrorMessage();
    final logger = Modular.get<Logger>();
    logger.i("isSuccess: ${userStoreController.isSuccess.value} \n"
        "isLoggedIn: ${userStoreController.isLoggedIn.value} \n");
    return Container(
      padding: EdgeInsets.only(top: 16.0.h),
      child: RoundedButtonGradientWidget(
          height: 48,
          textSize: 16,
          buttonText: 'login_btn_sign_in'.tr,
          buttonColor: AppColors.pinkGradientButton,
          textColor: Colors.white,
          onPressed: () async {
            if (userStoreController.isInvalidInputFields(context) || userStoreController.isPasswordBlank(context)) {
              return;
            }
            if (userStoreController.canLogin) {
              DeviceUtils.hideKeyboard(context);
              userStoreController.clearTextLogin();
              final result = await userStoreController.loginUsingAccount();
              userStoreController.handleLogin(result, context, '');
            } else {
              showErrorMessage.show(message: userStoreController.validateUserId(context), context: context,);
              showErrorMessage.show(message: userStoreController.validatePassword(context), context: context,);
            }
          }
      ),
    );
  }

}
