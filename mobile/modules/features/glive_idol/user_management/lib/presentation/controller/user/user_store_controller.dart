import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_management/domain/entity/request/otp.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/domain/entity/response/login_response.dart';
import 'package:user_management/domain/usecase/auth/get_otp.dart';
import 'package:user_management/domain/usecase/auth/refresh_token.dart';
import 'package:user_management/domain/usecase/auth/register.dart';
import 'package:user_management/domain/usecase/auth/verify_otp.dart';
import 'package:validators/validators.dart';

import '../../../domain/entity/response/profile_response.dart';

class UserStoreController extends GetxController {
  late SharedPreferenceHelper _sharedPrefsHelper;

  UserStoreController();

  RefreshToken _refreshToken = RefreshToken();

  var profile = ProfileResponse().obs;
  var isApproved = false.obs;
  var invalidEmailMsg = ''.obs;
  var invalidPasswordMsg = ''.obs;
  var errorMessage = ''.obs;
  var phoneCodeController = ''.obs;
  var phoneController = ''.obs;
  var emailController = ''.obs;
  var passwordController = ''.obs;
  var otpType = ''.obs;
  var verifyCodeInput = ''.obs;
  var optError = '.'.obs;
  var storageUrl = ''.obs;
  var avataEdit = ''.obs;
  var nickNameEdit = ''.obs;
  var introEdit = ''.obs;
  var invalidEditNickName = ''.obs;
  var editIntro = ''.obs;
  var editForte = ''.obs;
  var balance = ''.obs;
  var levelIdol = 1.obs;

  var loginWithPhone = true.obs;
  var isLoading = false.obs;
  var isSuccess = false.obs;
  var isLoggedIn = false.obs;
  var isNewUser = false.obs;
  var isBan= false.obs;
  var showPassword = false.obs;
  var isEnabledSubmitRegisterBtn = false.obs;
  var isEnabledStep1Button = true.obs;

  bool get canLogin => (
      loginWithPhone.value ? (phoneController.isNotEmpty && StringValidate.isPhoneNumberWithCode(phoneCodeController.value, phoneController.value))
          : (emailController.isNotEmpty && isEmail(emailController.value))
      ) && passwordController.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    SharedPreferenceHelper.getInstance().then((value) => _sharedPrefsHelper = value);
  }

  bool isInvalidInputFields(BuildContext context) {
    if (loginWithPhone.value) {
      if (StringValidate.isPhoneNumberWithCode(this.phoneCodeController.value, this.phoneController.value)) {
        return false;
      }
      invalidEmailMsg.value = 'login_error_phone_invalid'.tr;
      return true;
    } else {
      if (StringValidate.isEmail(this.emailController.value)) {
        return false;
      }
      invalidEmailMsg.value = 'login_error_email_invalid'.tr;
      return true;
    }
  }

  String validateUserId(BuildContext context) {
    if (loginWithPhone.value) {
      if (phoneCodeController.value.isEmpty || phoneController.value.isEmpty) {
        return 'login_error_phone_empty'.tr;
      } else if (!StringValidate.isPhoneNumberWithCode(phoneCodeController.value, phoneController.value)) {
        return 'login_error_phone_invalid'.tr;
      }
    } else {
      if (emailController.value.isEmpty) {
        return 'login_error_email_empty'.tr;
      } else if (!isEmail(emailController.value)) {
        return 'login_error_email_invalid'.tr;
      }
    }
    return '';
  }

  getAvataUrl(String urlImage) async{
    if(urlImage != ''){
      _sharedPrefsHelper = await SharedPreferenceHelper.getInstance();
      storageUrl.value = _sharedPrefsHelper.storageServer + '/' + _sharedPrefsHelper.bucketName + '/' + urlImage;
    }
  }

  String validatePassword(BuildContext context) {
    return passwordController.value.isEmpty
        ? 'login_error_password_empty'.tr
        : '';
  }

  bool isPasswordBlank(BuildContext context) {
    if (passwordController.value.isEmpty) {
      invalidPasswordMsg.value = 'login_error_password_blank'.tr;
      return true;
    }
    return false;
  }

  Future<void> refreshToken({bool logoutFailed = true}) async {
    _sharedPrefsHelper = await SharedPreferenceHelper.getInstance();
    if (_sharedPrefsHelper.refreshToken != null) {
      final respone = await _refreshToken.call(_sharedPrefsHelper.refreshToken ?? '');
      bool isSuccess = false;
      respone.fold(
            (failure) => logoutFailed ? this.logout() : isSuccess = true,
            (success) {
          this.loginSuccess(success);
          isSuccess = true;
        },
      );
      if (isSuccess) {
        return;
      }
    }
    this.logout();
  }

  Future<Either<Failure, GatewayResponse>> getOtp() async {
    _sharedPrefsHelper = SharedPreferenceHelper(await SharedPreferences.getInstance());
      OtpDto otpDto = new OtpDto(
      type: otpType.value,
      email: _sharedPrefsHelper.formEmail.toString(),
    );
    if (this.loginWithPhone.value) {
      otpDto = new OtpDto(
        type: 'phone',
        phoneCode: _sharedPrefsHelper.formPhoneCode.toString(),
        phoneNumber:  _sharedPrefsHelper.formPhone.toString(),
      );
    }
    GetOtp getOtp = GetOtp();
    return await getOtp.call(otpDto);
  }

  Future<Either<Failure, bool>> verifyOtp() async {
    _sharedPrefsHelper = SharedPreferenceHelper(await SharedPreferences.getInstance());
    OtpDto otpDto = new OtpDto(
      type: otpType.value,
      email: _sharedPrefsHelper.formEmail.toString(),
      verifyCode: verifyCodeInput.value,
    );
    if (this.loginWithPhone.value) {
      otpDto = new OtpDto(
        type: otpType.value,
        phoneCode: _sharedPrefsHelper.formPhoneCode.toString(),
        phoneNumber:  _sharedPrefsHelper.formPhone.toString(),
        verifyCode: verifyCodeInput.value,
      );
    }
    VerifyOtp verifyOtp = VerifyOtp();
    return await verifyOtp.call(otpDto);
  }

  Future<Either<Failure, bool>> register() async {
    _sharedPrefsHelper = SharedPreferenceHelper(await SharedPreferences.getInstance());
    RegisterParams registerParam = new RegisterParams(
      loginWithPhone: false,
      password: passwordController.value,
      email: _sharedPrefsHelper.formEmail.toString(),
      verifyCode: verifyCodeInput.value,
    );
    if (this.loginWithPhone.value) {
      registerParam = new RegisterParams(
        loginWithPhone: true,
        password: passwordController.value,
        phoneCode: _sharedPrefsHelper.formPhoneCode.toString(),
        phone: _sharedPrefsHelper.formPhone.toString(),
        verifyCode: verifyCodeInput.value,
      );
    }
    Register register = Register();
    return (await register.call(registerParam)).fold(
        (failure) => Left(failure),
        (success) {
          var data = LoginResponse.fromMap(success.data);
          _sharedPrefsHelper.setRegisteredID(data.username);
          loginSuccess(data);
          return Right(true);
      },
    );
  }

  void loginSuccess(LoginResponse loginResponse) {
    isLoggedIn.value = true;
    isNewUser.value = (loginResponse.isNew) ?? false;
    _sharedPrefsHelper.setIsLoggedIn(true);
    _sharedPrefsHelper.setAccessToken(loginResponse.accessToken);
    _sharedPrefsHelper.setRefreshToken(loginResponse.refreshToken);
    _sharedPrefsHelper.setIsNewUser(isNewUser.value);
  }

  void enabledSubmitRegisterBtn(){
    if (verifyCodeInput.value.isNotEmpty && verifyCodeInput.value.length >=6  && passwordController.value.length >= 6) {
      isEnabledSubmitRegisterBtn.value = true;
    }
    else {
      isEnabledSubmitRegisterBtn.value = false;
    }
  }

  void enabledStep1Button(){
    if ((phoneController.value.trim().isNotEmpty || emailController.value.trim().isNotEmpty) && passwordController.value.length >= 6) {
      isEnabledStep1Button.value = true;
    }
    else {
      isEnabledStep1Button.value = false;
    }
  }

  void setupRegister(){
    isEnabledStep1Button.value = false;
    invalidEmailMsg.value = '';
    invalidPasswordMsg.value = '';
  }

  logout() {
    emailController.value = '';
    phoneCodeController.value = '';
    phoneController.value = '';
    passwordController.value = '';
    isLoggedIn.value = false;
    isSuccess.value = false;
    _sharedPrefsHelper.removeAccessToken();
    _sharedPrefsHelper.removeRefreshToken();
    _sharedPrefsHelper.setIsLoggedIn(false);
    SocketClient.leave();
  }
}
