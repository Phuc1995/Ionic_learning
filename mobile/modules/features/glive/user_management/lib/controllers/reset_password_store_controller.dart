import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:telephony/telephony.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:user_management/service/auth_api_service.dart';
import 'package:validators/validators.dart';

class ResetPasswordStoreController extends GetxController {

  ResetPasswordStoreController();
  final _authService = Modular.get<AuthApiService>();
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
  var endTime = (DateTime.now().millisecondsSinceEpoch + 1000 * 0).obs;

  var isLoading = false.obs;
  var isSuccess = false.obs;
  var showPassword = false.obs;
  var isCountDownTime = true.obs;

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

  void confirmForgotPassword(BuildContext context) async {
    if (this.isInvalidInputFields(context) ||
        this.isPasswordInvalid(context) ||
        this.isVerifyInvalid(context)) {
      return;
    }
    DeviceUtils.hideKeyboard(context);
    this.isLoading.value = true;
    ResettingPasswordDto resetPasswordParams = new ResettingPasswordDto();
    if (this.loginWithPhone.value) {
      resetPasswordParams.phoneCode = this.phoneCodeController.value;
      resetPasswordParams.phoneNumber = this.phoneController.value;
    } else {
      resetPasswordParams.email = this.emailController.value;
    }
    resetPasswordParams.password = this.passwordController.value;
    resetPasswordParams.verifyCode = this.verifyController.value;
    final res = await _authService.resetPassword(data: resetPasswordParams);
    _handleChangePass(res, context);
    this.isLoading.value = false;
  }

  void _handleChangePass(Either<Failure, GatewayResponse> result, BuildContext context) {
    ShowErrorMessage showErrorMessage = ShowErrorMessage();
    result.fold((failure) {
      String errorMessage = 'forgot_password_error_unknown'.tr;
      if (failure is DioFailure && failure.messageCode == MessageCode.INCORRECT_OTP) {
        errorMessage = 'register_incorrect_otp'.tr;
      }
      showErrorMessage.show(
        message: errorMessage,
        context: context,
      );
    }, (GatewayResponse response) {
      if (response.messageCode == MessageCode.RESET_PASSWORD_SUCCESS) {
        DeviceUtils.hideKeyboard(context);
        ShowDialog().showMessage(context, "register_change_password_success_message".tr, "account_verify_confirm_button".tr, (){
          Modular.to.navigate(ViewerRoutes.login);
        });
        // Navigator.of(context).pushReplacementNamed(IdolRoutes.login);
      } else if (response.messageCode == MessageCode.SEND_OTP_TOO_QUICKLY) {
        showErrorMessage.show(
          message: 'request_otp_too_quick'.tr,
          context: context,
        );
      } else {
        showErrorMessage.show(
          message: 'forgot_password_error_unknown'.tr,
          context: context,
        );
      }
    });
  }

  handleSmsMessage(SmsMessage message, TextEditingController verifyCodeController) {
    if ((dotenv.env['OTP_FROM_ADDRESS']??'').isNotEmpty) {
      if (message.address != dotenv.env['OTP_FROM_ADDRESS'])
        return;
    }
    if (message.body != null) {
      String body = message.body??'';
      int index = body.indexOf(Strings.OTP_PATTERN);
      int start = index + Strings.OTP_PATTERN.length;
      int end = start + 6;
      if (index >= 0) {
        String otp = body.substring(start, end);
        verifyCodeController.text = otp;
        this.verifyController.value = otp;
      }
    }
  }

  Future<void> requestOTP(BuildContext context) async {
    ShowErrorMessage showErrorMessage = ShowErrorMessage();
    if (this.loginWithPhone.value) {
      String error = this.validatePhone(context);
      if (error.isNotEmpty) {
        showErrorMessage.show(
          message: error,
          context: context,
        );
        return;
      }
    } else {
      String error = this.validateEmail(context);
      if (error.isNotEmpty) {
        showErrorMessage.show(
          message: error,
          context: context,
        );
        return;
      }
    }

    CheckExistingUserParamsDto params = CheckExistingUserParamsDto(
      email: this.emailController.value,
      phoneCode: this.phoneCodeController.value,
      phone: this.phoneController.value,
      loginWithPhone: this.loginWithPhone.value,
    );
    final userExist =  await _authService.CheckExistingUser(params: params);
    userExist.fold((failure) {
      if (failure is DioFailure) {
        String errMessage = 'forgot_password_get_otp_error_unknown'.tr;
        if (failure.statusCode == 401 || failure.statusCode == 400) {
          errMessage = this.loginWithPhone.value ? 'forgot_password_phone_not_exist'.tr :'forgot_password_email_not_exist'.tr;
        }
        showErrorMessage.show(
          message: errMessage,
          context: context,
        );
        return;
      }
    }, (res) async {
      if (res.messageCode == MessageCode.USER_NOT_EXIST) {
        showErrorMessage.show(
          message: this.loginWithPhone.value ? 'forgot_password_phone_not_exist'.tr : 'forgot_password_email_not_exist'.tr,
          context: context,
        );
      } else {
        // If countdown time is running
        if (this.isCountDownTime.value == true) {
          return;
        }

        // end: If countdown time is running
        OtpDto requestOtpParams = new OtpDto();
        requestOtpParams.type = "email";
        requestOtpParams.email = this.emailController.value;
        if (this.loginWithPhone.value) {
          requestOtpParams = new OtpDto(
            type: 'sms',
            phoneCode: this.phoneCodeController.toString(),
            phoneNumber: this.phoneController.toString(),
          );
        }
        final otp = await _authService.getOtp(otp: requestOtpParams);

        otp.fold((failure) {
          if (failure is DioFailure) {
            showErrorMessage.show(
              message: 'forgot_password_get_otp_error_unknown'.tr,
              context: context,
            );
            return;
          }
        }, (res) {
          if (res.messageCode == MessageCode.SEND_OTP_SUCCESS) {
              int requestExpiredTimeInSecond = res.data['requestExpiredTimeInSecond'] ?? 60;
              this.endTime.value = DateTime.now().millisecondsSinceEpoch + 1000 * requestExpiredTimeInSecond;
              isCountDownTime.value = true;
          }
        });
      }
    });

  }
}
