import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:validators/validators.dart';

class LinkAccountStoreController extends GetxController {

  LinkAccountStoreController();

  var isPhone = true.obs;
  var invalidEmailMsg = ''.obs;
  var invalidPasswordMsg = ''.obs;
  var invalidVerifyMsg = ''.obs;
  var errorMessage = ''.obs;
  var emailController = ''.obs;
  var phoneCodeController = ''.obs;
  var phoneController = ''.obs;
  var verifyController = ''.obs;

  var isLoading = false.obs;
  var isSuccess = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  bool isInvalidInputFields(BuildContext context) {
    if (isPhone.value) {
      if (isPhoneNumber(this.phoneCodeController.value, this.phoneController.value)) {
        return false;
      }
      invalidEmailMsg.value = 'link_account_invalid_phone'.tr;
      return true;
    } else {
      if (isEmail(this.emailController.value)) {
        return false;
      }
      invalidEmailMsg.value = 'link_account_invalid_email'.tr;
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
      return 'link_account_phone_hint'.tr;
    } else if (!isPhoneNumber(phoneCodeController.value, phoneController.value)) {
      return 'link_account_invalid_phone'.tr;
    }
    return '';
  }

  String validateEmail(BuildContext context) {
    if (emailController.value.isEmpty) {
      return 'link_account_email_hint'.tr;
    } else if (!isEmail(emailController.value)) {
      return 'link_account_invalid_email'.tr;
    }
    return '';
  }

  bool isVerifyInvalid(BuildContext context) {
    if (verifyController.value.isEmpty) {
      invalidVerifyMsg.value = 'link_account_otp_hint'.tr;
      return true;
    }
    return false;
  }
}
