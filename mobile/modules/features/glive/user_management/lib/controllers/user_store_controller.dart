import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:common_module/common_module.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:live_stream/presentation/controller/live/category_controller.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';
import 'package:logger/logger.dart';
import 'package:payment/contants/contants.dart';
import 'package:payment/controllers/controllers.dart';
import 'package:payment/dto/dto.dart';
import 'package:payment/service/top_up_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:user_management/constants/social_signin_types.dart';
import 'package:user_management/controllers/follow_controller.dart';
import 'package:user_management/controllers/notification_controller.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:user_management/repositorise/user_info_api_repository.dart';
import 'package:validators/validators.dart';

import '../service/auth_api_service.dart';

class UserStoreController extends GetxController {
  late SharedPreferenceHelper _sharedPrefsHelper;

  UserStoreController();
  final UserInfoApiRepository _accountInfoApi = Modular.get<UserInfoApiRepository>();
  final logger = Modular.get<Logger>();
  final _authService = Modular.get<AuthApiService>();
  var invalidEmailMsg = ''.obs;
  var invalidPasswordMsg = ''.obs;
  var errorMessage = ''.obs;
  var emailController = ''.obs;
  var phoneCodeController = ''.obs;
  var phoneController = ''.obs;
  var passwordController = ''.obs;
  var otpType = ''.obs;
  var verifyCodeInput = ''.obs;
  var optError = '.'.obs;
  var storageUrl = ''.obs;
  var avartarUrl = ''.obs;
  var avatarEdit = ''.obs;
  var gliveIdEdit = ''.obs;
  var fullNameEdit = ''.obs;
  var invalidEditNickName = ''.obs;
  var editValue = ''.obs;
  var editGender = ''.obs;
  var editBirthday = ''.obs;
  var editIntro = ''.obs;
  var editAddress = ''.obs;
  var balance = '0'.obs;
  var errEditNickName = "".obs;

  var loginWithPhone = true.obs;
  var isLoading = false.obs;
  var isInfoLoading = false.obs;
  var isSuccess = false.obs;
  var isLoggedIn = false.obs;
  var isNewUser = false.obs;
  var isBan = false.obs;
  var showPassword = false.obs;
  var isEnabledSubmitRegisterBtn = false.obs;
  var isEnabledStep1Button = true.obs;
  var isAllSwitched = false.obs;
  var profile = ProfileResponseDto().obs;

  bool isApproved = false;

  bool get canLogin =>
      (
          loginWithPhone.value ? (phoneController.isNotEmpty &&
              StringValidate.isPhoneNumberWithCode(
                  phoneCodeController.value, phoneController.value))
              : (emailController.isNotEmpty && isEmail(emailController.value))
      ) && passwordController.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    SharedPreferenceHelper.getInstance().then((value) async {
      _sharedPrefsHelper = value;
      storageUrl.value = _sharedPrefsHelper.storageServer + '/' +
          _sharedPrefsHelper.bucketName + '/';
    });
  }

  bool isInvalidInputFields(BuildContext context) {
    if (loginWithPhone.value) {
      if (StringValidate.isPhoneNumberWithCode(
          this.phoneCodeController.value, this.phoneController.value)) {
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
      } else if (!StringValidate.isPhoneNumberWithCode(
          phoneCodeController.value, phoneController.value)) {
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

  getAvatarUrl(String urlImage) async {
    if (urlImage != '') {
      _sharedPrefsHelper = await SharedPreferenceHelper.getInstance();
      avartarUrl.value = _sharedPrefsHelper.storageServer + '/' +
          _sharedPrefsHelper.bucketName + '/' + urlImage;
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

  Future<void> refreshToken({bool logoutFailed = true }) async {
    _sharedPrefsHelper = await SharedPreferenceHelper.getInstance();
    if (_sharedPrefsHelper.refreshToken != null) {
      final response = await _authService.refreshToken(token: _sharedPrefsHelper.refreshToken ?? '');
      bool isSuccess = false;
      response.fold(
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
    _sharedPrefsHelper =
        SharedPreferenceHelper(await SharedPreferences.getInstance());
    OtpDto otpDto = new OtpDto(
      type: otpType.value,
      email: _sharedPrefsHelper.formEmail.toString(),
    );
    if (this.loginWithPhone.value) {
      otpDto = new OtpDto(
        type: otpType.value,
        phoneCode: _sharedPrefsHelper.formPhoneCode.toString(),
        phoneNumber: _sharedPrefsHelper.formPhone.toString(),
      );
    }
    return await _authService.getOtp(otp: otpDto);
  }

  Future<Either<Failure, bool>> verifyOtp() async {
    _sharedPrefsHelper =
        SharedPreferenceHelper(await SharedPreferences.getInstance());
    OtpDto otpDto = new OtpDto(
      type: otpType.value,
      email: _sharedPrefsHelper.formEmail.toString(),
      verifyCode: verifyCodeInput.value,
    );
    if (this.loginWithPhone.value) {
      otpDto = new OtpDto(
        type: otpType.value,
        phoneCode: _sharedPrefsHelper.formPhoneCode.toString(),
        phoneNumber: _sharedPrefsHelper.formPhone.toString(),
        verifyCode: verifyCodeInput.value,
      );
    }
    return await _authService.verifyOtp(otp: otpDto);
  }

  Future<Either<Failure, bool>> register() async {
    _sharedPrefsHelper =
        SharedPreferenceHelper(await SharedPreferences.getInstance());
    RegisterParamsDto registerParam = new RegisterParamsDto(
      loginWithPhone: false,
      password: passwordController.value,
      email: _sharedPrefsHelper.formEmail.toString(),
      verifyCode: verifyCodeInput.value,
    );
    if (this.loginWithPhone.value) {
      registerParam = new RegisterParamsDto(
        loginWithPhone: true,
        password: passwordController.value,
        phoneCode: _sharedPrefsHelper.formPhoneCode.toString(),
        phone: _sharedPrefsHelper.formPhone.toString(),
        verifyCode: verifyCodeInput.value,
      );
    }
    return (await _authService.register(params: registerParam)).fold(
          (failure) => Left(failure),
          (success) {
        var data = LoginResponseDto.fromMap(success.data);
        _sharedPrefsHelper.setRegisteredID(data.username);
        loginSuccess(data);
        return Right(true);
      },
    );
  }

  void loginSuccess(LoginResponseDto loginResponse) {
    this.isLoading.value = false;
    this.isLoggedIn.value = true;
    this.isNewUser.value = (loginResponse.isNewUser) ?? false;
    this._sharedPrefsHelper.setIsLoggedIn(true);
    this._sharedPrefsHelper.setAccessToken(loginResponse.accessToken);
    this._sharedPrefsHelper.setRefreshToken(loginResponse.refreshToken);
    this._sharedPrefsHelper.setIsNewUser(isNewUser.value);
  }

  void enabledSubmitRegisterBtn() {
    if (verifyCodeInput.value.isNotEmpty && verifyCodeInput.value.length >= 6 &&
        passwordController.value.length >= 6) {
      isEnabledSubmitRegisterBtn.value = true;
    }
    else {
      isEnabledSubmitRegisterBtn.value = false;
    }
  }

  void updateInfo({required Rx<String> editField, required String field}) async {
    if (editField.value != editValue.value) {
      final response = await _authService.updateViewerInfo(
          params: InfoParamsDto(field: field, content: editValue.value));
      response.fold((failure) {}, (success) {
        editField.value = editValue.value.trim();
        Modular.to.pop();
      });
    } else {
      Modular.to.pop();
    }
  }

  Future<Either<Failure, bool>>  updateViewerInfo({required dynamic content, required String field}) async {
      return await _authService.updateViewerInfo(params: InfoParamsDto(field: field, content: content));
  }

  void enabledStep1Button() {
    if ((phoneController.value
        .trim()
        .isNotEmpty || emailController.value
        .trim()
        .isNotEmpty) && passwordController.value.length >= 6) {
      isEnabledStep1Button.value = true;
    }
    else {
      isEnabledStep1Button.value = false;
    }
  }

  void setupRegister() {
    isEnabledStep1Button.value = false;
    invalidEmailMsg.value = '';
    invalidPasswordMsg.value = '';
  }

  Future fetchData() async {
    final UserInfoApiRepository _accountInfoApi = Modular.get<
        UserInfoApiRepository>();
    var responses = await Future.wait([
      _accountInfoApi.fetchProfile(),
    ]);
    responses[0].fold((l) => null, (res) {
      if (res.data != null) {
        this.profile.value = ProfileResponseDto.fromMap(res.data);
      } else {
        this.profile.value = new ProfileResponseDto();
      }
      this.balance.value = this.profile.value.balance ?? '0';
      this.profile.refresh();
    });
  }

  logout() {
    emailController.value = '';
    phoneCodeController.value = '';
    phoneController.value = '';
    passwordController.value = '';
    isLoggedIn.value = false;
    isSuccess.value = false;
    isLoading.value = false;
    _sharedPrefsHelper.removeAccessToken();
    _sharedPrefsHelper.removeRefreshToken();
    _sharedPrefsHelper.setIsLoggedIn(false);
    _sharedPrefsHelper.setUserUuid('');
    SocketClient.leave();
  }

  Future updateDeviceInfo(DeviceInfoDto deviceInfo, String token) async {
    return await _authService.updateDeviceInfo(DeviceInfoParamDto(
        deviceId: deviceInfo.deviceId,
        deviceModel: deviceInfo.deviceModel,
        fcmToken: token));
  }

  Future removeDeviceInfo() async {
    final deviceInfo = await DeviceUtils.getDeviceId();
    await _authService.removeDeviceInfo(RemoveInfoParamsDto(deviceId: deviceInfo.deviceId));
    this.logout();
    _sharedPrefsHelper.clearAll();
    Modular.to.navigate(ViewerRoutes.login);
  }

  Future checkAccessStatusUser() async {
    return await _authService.checkAccessStatusUser();
  }

  Future checkExistingUser(CheckExistingUserParamsDto params) async {
    return await _authService.checkExistingUser(params: params);
  }

  Future loginUsingApple() async {
    return await _authService.loginSocialNetwork(signInType: SocialSignInType.apple);
  }

  Future loginUsingFacebook() async {
    return await _authService.loginSocialNetwork(signInType: SocialSignInType.facebook);
  }

  Future loginUsingGoogle() async {
    return await _authService.loginSocialNetwork(signInType: SocialSignInType.google);
  }

  Future loginUsingZalo() async {
    return await _authService.loginSocialNetwork(signInType: SocialSignInType.zalo);
  }

  Future loginUsingAccount() async {
    return await _authService.loginWithAccount(params: AccountParamsDto(
      loginWithPhone: this.loginWithPhone.value,
      password: this.passwordController.value,
      email: this.emailController.value,
      phoneCode: this.phoneCodeController.value,
      phone: this.phoneController.value,
    ));
  }

  void onPressedEditIntro({required BuildContext context, required ProfileResponseDto profile, required TextEditingController textEditingController}) async {
    this.isLoading.value = true;
    profile.intro = textEditingController.text;
    final response = await this.updateViewerInfo(field: "intro", content: profile.intro!);
    response.fold((failure) {
      this.isLoading.value = false;
      ShowErrorMessage().show(context: context, message: "edit_user_info_message_error".tr);
    }, (success) {
      this.editIntro.value = textEditingController.text;
      this.isLoading.value = false;
      Modular.to.pop();
    });
  }

  void onPressedEditNickName({required ProfileResponseDto profile, required BuildContext context, required TextEditingController textEditingController}) async {
    if (("" + textEditingController.text).trim() == "") {
      textEditingController.text = ("" + textEditingController.text).trim();
      ShowErrorMessage().show(context: context, message: "edit_user_info_nick_name_empty".tr);
    } else if (textEditingController.text.trim().length < 5 || textEditingController.text.trim().length > 16 || !StringValidate.isViewerID(textEditingController.text.trim())){
      this.errEditNickName.value = "edit_user_info_nick_name_err_string".tr;
    } else {
      this.isLoading.value = true;
      final response = await this.updateViewerInfo(field: "gId", content: textEditingController.text.trim());
      response.fold((failure) {
        this.isLoading.value = false;
        if (failure is DioFailure) {
          if (failure.messageCode == MessageCode.NICK_NAME_EXIST) {
            ShowErrorMessage().show(context: context, message: "edit_user_info_nick_name_exist".tr);
          } else {
            ShowErrorMessage().show(context: context, message: "edit_user_info_message_error".tr);
          }
        } else {
          ShowErrorMessage().show(context: context, message: "edit_user_info_message_error".tr);
        }
      }, (success) {
        this.isLoading.value = false;
        profile.gId = textEditingController.text.trim();
        this.gliveIdEdit.value = textEditingController.text.trim();
        Modular.to.pop();
      });
    }
  }

  Future countUnreadNotification() async {
    return await _authService.loginSocialNetwork(signInType: SocialSignInType.facebook);
  }

  StreamSubscription<ReceivedAction> notificationSubjects() {
    return NotificationSubjects.actionStream.listen((receivedAction) {
      if (receivedAction.payload != null) {
        final type = receivedAction.payload![FirebaseConstants.TYPE];
        final detail = receivedAction.payload![FirebaseConstants.DETAIL] ?? '';
        switch (type) {
          case FirebaseConstants.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_SUCCESS:
          case FirebaseConstants.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_FAILED:
            FirebaseMessage.loadSingletonPage(
                targetPage: ViewerRoutes.payment_recharge_history,
                arguments: receivedAction);
            break;
          case FirebaseConstants.IDOL_LIVESTREAM:
            if (detail.isNotEmpty) {
              final roomData = ViewerLiveRoomDto.fromMap(jsonDecode(detail));
              LiveController liveController = Get.put(LiveController());
              liveController.currentRoom.value = roomData;
              liveController.currentRoom.refresh();
              // Modular.to.push(MaterialPageRoute(builder: (context) => LiveChannelIdolPage(roomData: liveController.currentRoom.value,)));
              FirebaseMessage.loadSingletonPage(
                  targetPage: ViewerRoutes.live_channel_idol,
                  arguments: {
                    'roomData': roomData,
                  });
            }
            break;
          default:
            FirebaseMessage.loadSingletonPage(
                targetPage: ViewerRoutes.notification_page,
                arguments: receivedAction);
            break;
        }
      }
    });
  }

  handleNotification(payload) {
    FollowController _followController = Get.put(FollowController());
    final message = SocketMessage.fromMap(payload);
    if (!message.silent) {
      var historyRouter = Modular.to.navigateHistory;
      int livePageIndex = historyRouter.indexWhere((element) {
        return element.name == ViewerRoutes.live_channel_idol;
      });
      if(livePageIndex <= 0 ){
        FirebaseMessage.showMessage(message);
      }
      //refresh list idol streaming when idol live
      _followController.idolStreaming.clear();
      _followController.getIdolStreaming();
      int idolFollowedIndex =  _followController.idolList.indexWhere((ele) => ele.uuid == payload['data']['id']);
      if(idolFollowedIndex >= 0){
        _followController.idolList[idolFollowedIndex].isStreaming = true;
        _followController.idolList.refresh();
      }
    }
    if (message.data != null) {
      switch (message.type){
        case FirebaseConstants.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_SUCCESS:
          Future.delayed(Duration(seconds: 5), (){
            this.fetchProfile();
          });
          break;
      }
    }
  }

  Future<void> fetchProfile() async {
    this.isLoading.value = true;
    final either = await _accountInfoApi.fetchProfile();
    either.fold((l) {
      this.isLoading.value = false;
      Modular.to.pushReplacementNamed(ViewerRoutes.login);
    }, (res) {
      this.isLoading.value = false;
        if (res.data != null) {
          CategoryController categoryController = Get.put(CategoryController());
          this.profile.value = ProfileResponseDto.fromMap(res.data);
          categoryController.balance.value = int.parse(this.profile.value.balance ?? '0');
          isApproved = this.profile.value.identity != null ? this.profile.value.identity!.statusVerify == 'APPROVED' : false;
          _sharedPrefsHelper.setUserUuid(this.profile.value.uuid);
          String name = '';
          if(this.profile.value.fullName != null && this.profile.value.fullName!.isNotEmpty ) {
            name = this.profile.value.fullName!;
          } else name = this.profile.value.username;
          _sharedPrefsHelper.setUserNameSupport(name);
          _sharedPrefsHelper.setUserMaiSupport(this.profile.value.email);
          SocketClient.userUuid = this.profile.value.uuid;
          SocketClient.join();
          this.balance.value = this.profile.value.balance!;
        } else {
          this.profile.value = new ProfileResponseDto();
          isApproved = false;
        }
    });
  }

  void onRechargeNew(message) {
    RechargeInformationDto information = RechargeInformationDto.fromSocketWaitingMap(message['data']);
    this.handleSocketRecharge(message['data'], status: StatusType.NEW.name, information: information);
  }

  void handleSocketRecharge(dynamic decode, {required String status, required RechargeInformationDto information}) async {
    try {
      var historyRouter = Modular.to.navigateHistory;
      if(historyRouter.last.name == ViewerRoutes.payment_crypto ){
        Modular.to.pushNamed(ViewerRoutes.payment_information, arguments: {'information': information});
      } else if (historyRouter.last.name == ViewerRoutes.payment_recharge_history ) {
        RechargeHistoryController _controller = Get.put(RechargeHistoryController());
        if(_controller.statusFilter == PaymentContants.ALL.obs || (status == PaymentContants.COMPLETED && _controller.statusFilter == PaymentContants.COMPLETED.obs)) _controller.addItemRechargeHistory(decode);
        if(status == PaymentContants.FAILED && _controller.statusFilter == PaymentContants.FAILED.obs) _controller.addItemRechargeHistory(decode);;
      }
    } catch (e){
      logger.e(e);
    }
  }

  void onRechargeSuccess(message) {
    Future.delayed(Duration(seconds: 5), (){
      this.fetchProfile();
    });
    RechargeInformationDto information = RechargeInformationDto.fromMap(message['data']);
    this.handleSocketRecharge(message['data'], status: StatusType.COMPLETED.name, information: information);
  }

  void onRechargeFailed(message) {
    RechargeInformationDto information = RechargeInformationDto.fromMap(message['data']);
    if(message['content'].toString().isNotEmpty){
      information.messageErr = message['content'];
    }
    handleSocketRecharge(message['data'], status: StatusType.FAILED.name, information: information);
  }

  void onRechargeWaiting(message) {
    RechargeInformationDto information = RechargeInformationDto.fromSocketWaitingMap(message['data']);
    this.handleSocketRecharge(message['data'], status: StatusType.MANUAL_WAITING_RECHARGE.name, information: information);
  }

  void clearTextLogin(){
    this.errorMessage.value = "";
    this.isLoading.value = true;
    this.isSuccess.value = false;
  }

  void handleLogin(Either<Failure, LoginResponseDto> result, BuildContext context, String errMessage){
    result.fold((failure) async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        failure = NetworkFailure();
      }

      if(failure is DioFailure) {
        String errMessage = 'login_error_unknown'.tr;
        if(failure.statusCode == 401 || failure.statusCode ==400){
          errMessage = this.loginWithPhone.value ? 'login_phone_error_failed'.tr : 'login_error_failed'.tr;
        }
        this.errorMessage.value = errMessage.tr;
      }
      this.isSuccess.value = false;
      this.isLoading.value = false;
      this.logout();

    }, (loginResponse) async {
      this.loginSuccess(loginResponse);
      if((loginResponse.isNewUser) ?? false){
        Modular.to.pushNamed(ViewerRoutes.accountComplete);
      }else{
        final res = await this.checkAccessStatusUser();
        this._handleBanUser(res,context);
      }
    });
  }

  void _handleBanUser(Either<Failure, AccessStatusResponseDto> result, BuildContext context){
    this.isLoading.value = false;
    result.fold((failure) {
      this..errorMessage.value = 'login_error_unknown'.tr;
    }, (res) async {
      if(res.banData != null){
        this.isBan.value = true;
        this.isSuccess.value = false;
        this.isLoggedIn.value = false;
        this.logout();
      }else{
        this.isSuccess.value = true;
        this.isLoggedIn.value = true;
        logger.i("isSuccess: ${this.isSuccess.value} \n"
            "isLoggedIn: ${this.isLoggedIn.value} \n"
        );
      }
    });
  }

  void onPressedHomeRecharge(bool isWaiting) async {
    if(isWaiting) {
      return;
    }
    isWaiting = true;
    final _topUpService = Modular.get<TopUpService>();
    await _topUpService.getTopUpCache()..
    fold((l) {
      isWaiting = false;
      var history = Modular.to.navigateHistory;
      final currentRoute = history.last.name;
      if (currentRoute != ViewerRoutes.payment_crypto) {
        Modular.to.pushNamed(ViewerRoutes.payment_crypto);
      }
    }, (data) {
      isWaiting = false;
      var history = Modular.to.navigateHistory;
      final currentRoute = history.last.name;
      if(data != null && currentRoute != ViewerRoutes.payment_information){
        Modular.to.pushNamed(ViewerRoutes.payment_information, arguments: {'information': data});
      } else if (currentRoute != ViewerRoutes.payment_crypto) {
        Modular.to.pushNamed(ViewerRoutes.payment_crypto);
      }
    });
  }

  Future<void> refreshInfo(Function? onRefresh) async {
    NotificationController _notificationController = Get.put(NotificationController());
    this.isInfoLoading.value = true;
    _notificationController.countUnreadNotification();
    var responses = await Future.wait([
      _accountInfoApi.fetchProfile(),
    ]);
    responses[0].fold((l) => null, (res) {
      if (res.data != null) {
        this.profile.value = ProfileResponseDto.fromMap(res.data);
      } else {
        this.profile.value = new ProfileResponseDto();
      }
      String name = '';
      if(this.profile.value.fullName != null && this.profile.value.fullName!.isNotEmpty ) {
        name = this.profile.value.fullName!;
      } else name = this.profile.value.username;
      _sharedPrefsHelper.setUserNameSupport(name);
      _sharedPrefsHelper.setUserMaiSupport(this.profile.value.email);
      this.balance.value = this.profile.value.balance??'0';
      this.profile.refresh();
      if (onRefresh != null) {
        onRefresh();
      }
    });
    this.isInfoLoading.value = false;
  }

  void handleRegister(Either<Failure, bool> verifyOtp, BuildContext context, ShowErrorMessage showErrorMessage) {
    verifyOtp.fold((failure) {
      DeviceUtils.hideKeyboard(context);
      this.isLoading.value = false;
      String errorMessage = ('register_error_message').tr;
      if (failure is DioFailure && failure.messageCode == MessageCode.INCORRECT_OTP) {
        errorMessage = ('register_incorrect_otp').tr;
      }
      showErrorMessage.show(context: context, message: errorMessage);
    }, (isSuccess) async {
      DeviceUtils.hideKeyboard(context);
      this.isLoading.value = false;
      if (isSuccess) {
        final register = await this.register();
        register.fold(
                (failure) =>
                showErrorMessage.show(context: context, message: ('register_error_unknown').tr),
                (isSuccess) {
              Modular.to.navigate(ViewerRoutes.account_complete);
            });
      } else {
        showErrorMessage.show(context: context, message: ('register_error_unknown').tr);
      }
    });
  }


  handleSmsMessage(SmsMessage message, TextEditingController _otpController) {
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
        _otpController.text = otp;
        this.verifyCodeInput.value = otp;
        this.isEnabledSubmitRegisterBtn.value = true;
      }
    }
  }

  void handleReceiveOtpFailure(Failure failure, BuildContext context) {
    ShowErrorMessage showErrorMessage = ShowErrorMessage();
    if (failure is DioFailure) {
      showErrorMessage.show(
        message: 'register_get_otp_error_unknown'.tr,
        context: context,
      );
      return;
    }
  }

  void handleReceiveOtpSuccess(GatewayResponse res, bool isCountDownTime, RxInt endTime) {
    if (res.messageCode == MessageCode.SEND_OTP_SUCCESS) {
      int requestExpiredTimeInSecond = res.data['requestExpiredTimeInSecond'] ?? 60;
      endTime.value = DateTime.now().millisecondsSinceEpoch + 1000 * requestExpiredTimeInSecond;
      isCountDownTime = true;
    }
  }


}
