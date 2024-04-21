import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:user_management/service/auth_api_service.dart';
import 'package:validators/validators.dart';

class LinkAccountStoreController extends GetxController {

  LinkAccountStoreController();
  final _authService = Modular.get<AuthApiService>();
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

  Future linkAccount(LinkAccountParamsDto data) async {
    return await _authService.linkAccount(params: data);
  }

  Future getOtp(OtpDto otp) async {
    return await _authService.getOtp(otp: otp);
  }

  handleLinkAccount(Either<Failure, GatewayResponse> result, BuildContext context) {
    ShowErrorMessage showErrorMessage = ShowErrorMessage();
    result.fold((failure) {
      this.isLoading.value = false;
      String errorMessage = 'link_account_error_unknown'.tr;
      if (failure is DioFailure) {
        if (failure.messageCode == MessageCode.INCORRECT_OTP) {
          errorMessage = 'link_account_incorrect_otp'.tr;
        } else if (failure.messageCode == MessageCode.LINK_ACCOUNT_EXISTING) {
          errorMessage = this.isPhone.value ? 'link_account_existed_phone'.tr : 'link_account_existed_email'.tr;
        }
      }
      showErrorMessage.show(
        message: errorMessage,
        context: context,
      );
    }, (res) {
      this.isLoading.value = false;
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

  String hideMobile(String mobile) {
    if (mobile.isEmpty) return '';
    if (mobile.length == 8) {
      return mobile.substring(0, 4) + '***' + mobile.substring(mobile.length - 2);
    } else if (mobile.length > 8) {
      return mobile.substring(0, 4) + '***' + mobile.substring(mobile.length - 4);
    } else {
      return mobile;
    }
  }

  String hideEmail(String email) {
    if (email.isEmpty) return '';
    List<String> strs = email.split('@');
    if (strs.length > 1) {
      String start = strs[0];
      if (strs[0].length > 3) {
        start = strs[0].substring(0, 3);
      }
      int dotIndex = strs[1].indexOf('.');
      String end = strs[1].substring(dotIndex);
      return start + '***@***' + end;
    } else {
      return email;
    }
  }

}
