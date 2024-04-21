import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/domain/entity/response/login_response.dart';
import 'package:validators/validators.dart';

class ResetPasswordStoreController extends GetxController {

  ResetPasswordStoreController();

  var loginWithPhone = true.obs;
  var invalidEmailMsg = ''.obs;
  var invalidPasswordMsg = ''.obs;
  var invalidVerifyMsg = ''.obs;
  var errorMessage = ''.obs;
  var emailController = ''.obs;
  var phoneCodeController = ''.obs;
  var phoneController = ''.obs;
  var passwordController = ''.obs;
  var verifyController = ''.obs;

  var isLoading = false.obs;
  var isSuccess = false.obs;
  var showPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  bool isInvalidInputFields(BuildContext context) {
    if (loginWithPhone.value) {
      if (isPhoneNumber(this.phoneCodeController.value, this.phoneController.value)) {
        return false;
      }
      invalidEmailMsg.value = 'forgot_password_invalid_phone'.tr;
      return true;
    } else {
      if (isEmail(this.emailController.value)) {
        return false;
      }
      invalidEmailMsg.value = 'forgot_password_invalid_email'.tr;
      return true;
    }
  }

  bool isPhoneNumber(String code, String phone) {
    // Null or empty string is invalid phone number
    // The minimum length is 4 for Saint Helena (Format: +290 XXXX) and Niue (Format: +683 XXXX).
    if (code.trim().isEmpty || phone.trim().isEmpty || phone.trim().length < 4 || phone.trim().length > 15) {
      return false;
    }

    // You may need to change this pattern to fit your requirement.
    // I just copied the pattern from here: https://regexr.com/3c53v
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(code+phone)) {
      return false;
    }
    return true;
  }

  String validatePhone(BuildContext context) {
    if (phoneCodeController.value.isEmpty || phoneController.value.isEmpty) {
      return 'forgot_password_empty_phone'.tr;
    } else if (!isPhoneNumber(phoneCodeController.value, phoneController.value)) {
      return 'forgot_password_invalid_phone'.tr;
    }
    return '';
  }

  String validateEmail(BuildContext context) {
    if (emailController.value.isEmpty) {
      return 'forgot_password_empty_email'.tr;
    } else if (!isEmail(emailController.value)) {
      return 'forgot_password_invalid_email'.tr;
    }
    return '';
  }

  String validatePassword(BuildContext context) {
    return passwordController.value.isEmpty
        ? 'login_error_password_empty'.tr
        : '';
  }

  bool isPasswordInvalid(BuildContext context) {
    if (passwordController.value.isEmpty) {
      invalidPasswordMsg.value = 'forgot_password_empty_password'.tr;
      return true;
    }
    if (passwordController.value.length < 6 ) {
      invalidPasswordMsg.value = 'forgot_password_min_password'.tr;
      return true;
    }
    if (passwordController.value.length > 50 ) {
      invalidPasswordMsg.value = 'forgot_password_max_password'.tr;
      return true;
    }
    return false;
  }

  bool isVerifyInvalid(BuildContext context) {
    if (verifyController.value.isEmpty) {
      invalidVerifyMsg.value = 'register_verify_code_hint'.tr;
      return true;
    }
    return false;
  }
}
