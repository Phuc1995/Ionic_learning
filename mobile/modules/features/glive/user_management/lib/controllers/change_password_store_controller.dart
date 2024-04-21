import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:user_management/service/auth_api_service.dart';

import '../dto/change_password_param_dto.dart';

class ChangePasswordStoreController extends GetxController {

  ChangePasswordStoreController();
  final _authService = Modular.get<AuthApiService>();
  var isCreatePassword = false.obs;
  var errorMessage = ''.obs;
  var passwordController = ''.obs;
  var newPasswordController = ''.obs;
  var confirmPasswordController = ''.obs;
  var invalidPasswordMsg = ''.obs;
  var invalidNewPasswordMsg = ''.obs;
  var invalidConfirmPasswordMsg = ''.obs;
  var showPassword = false.obs;
  var showNewPassword = false.obs;
  var showConfirmPassword = false.obs;

  var isLoading = false.obs;
  var isSuccess = false.obs;
  static int PASSWORD_MIN_LENGTH = 6;
  static int PASSWORD_MAX_LENGTH = 50;

  @override
  void onInit() {
    super.onInit();
  }

  bool validate() {
    invalidPasswordMsg.value = '';
    invalidNewPasswordMsg.value = '';
    invalidConfirmPasswordMsg.value = '';
    return (isCreatePassword.value ? true : validatePassword()) && validateNewPassword() && validateConfirmPassword();
  }

  bool validatePassword() {
    if (passwordController.value.isEmpty) {
      invalidPasswordMsg.value = 'change_password_empty_old_password'.tr;
      return false;
    }
    return true;
  }

  bool validateNewPassword() {
    if (newPasswordController.value.isEmpty) {
      invalidNewPasswordMsg.value = 'change_password_empty_password'.tr;
      return false;
    }
    if (newPasswordController.value.length < PASSWORD_MIN_LENGTH ) {
      invalidNewPasswordMsg.value = 'change_password_min_password'.tr;
      return false;
    }
    if (newPasswordController.value.length > PASSWORD_MAX_LENGTH ) {
      invalidNewPasswordMsg.value = 'change_password_max_password'.tr;
      return false;
    }
    return true;
  }

  bool validateConfirmPassword() {
    if (confirmPasswordController.value != newPasswordController.value) {
      invalidConfirmPasswordMsg.value = 'change_password_confirm_not_match'.tr;
      return false;
    }
    return true;
  }

  Future changePassword(ChangePasswordParamsDto data) async {
    return await _authService.changePassword(data: data);
  }

  handleChangePass(Either<Failure, GatewayResponse> result, BuildContext context) {
    ShowErrorMessage showErrorMessage = ShowErrorMessage();
    result.fold((failure) {
      this.isLoading.value = false;
      DeviceUtils.hideKeyboard(context);
      String errorMessage = 'change_password_error_unknown'.tr;
      if (failure is DioFailure) {
        if (failure.messageCode == MessageCode.PASSWORD_INCORRECT) {
          this.invalidPasswordMsg.value = 'change_password_password_incorrect'.tr;
          return;
        }
        if (failure.messageCode == MessageCode.USER_NOT_FOUND) {
          ShowDialog().showMessage(context, "change_password_user_not_found".tr, "button_close".tr, (){
            Modular.to.pushReplacementNamed(ViewerRoutes.login);
          });
          return;
        }
      }
      showErrorMessage.show(
        message: errorMessage,
        context: context,
      );
    }, (res) {
      this.isLoading.value = false;
      DeviceUtils.hideKeyboard(context);
      Get.delete<ChangePasswordStoreController>();
      ShowDialog().showMessage(context, "change_password_success".tr, "button_close".tr, (){
        Modular.to.pop();
        Modular.to.pop();
      });
    });
  }

}
