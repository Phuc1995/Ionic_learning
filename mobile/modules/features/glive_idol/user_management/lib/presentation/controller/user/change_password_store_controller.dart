import 'package:get/get.dart';

class ChangePasswordStoreController extends GetxController {

  ChangePasswordStoreController();

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

}
