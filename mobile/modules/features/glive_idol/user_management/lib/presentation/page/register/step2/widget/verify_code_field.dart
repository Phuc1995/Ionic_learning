import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyCodeRegister extends StatefulWidget {
  final UserStoreController userStoreController;

  const VerifyCodeRegister({Key? key, required this.userStoreController}) : super(key: key);

  @override
  _VerifyCodeRegisterState createState() => _VerifyCodeRegisterState();
}

class _VerifyCodeRegisterState extends State<VerifyCodeRegister> {
  final telephony = Telephony.instance;
  ShowErrorMessage showErrorMessage = ShowErrorMessage();
  TextEditingController _otpController = TextEditingController();
  ShowErrorMessage _showErrorMessage = ShowErrorMessage();
  late Future<void> _initializeControllerFuture;
  late SharedPreferenceHelper _sharedPrefsHelper;

  var endTime = (DateTime.now().millisecondsSinceEpoch + 1000 * 60).obs;
  bool isCountDownTime = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeControllerFuture = Future.wait([asyncInit()]);
    widget.userStoreController.otpType.value = 'email';
    widget.userStoreController.getOtp().then((data) {
      data.fold((failure) {
        _handleReceiveOtpFailure(failure);
      }, (res) {
        _handleReceiveOtpSuccess(res);
      });
    });
  }

  void _handleReceiveOtpFailure(Failure failure) {
    if (failure is DioFailure) {
      showErrorMessage.show(
        message: 'register_get_otp_error_unknown'.tr,
        context: context,
      );
      return;
    }
  }

  void _handleReceiveOtpSuccess(GatewayResponse res) {
    if (res.messageCode == MessageCode.SEND_OTP_SUCCESS) {
      int requestExpiredTimeInSecond = res.data['requestExpiredTimeInSecond'] ?? 60;
      endTime.value = DateTime.now().millisecondsSinceEpoch + 1000 * requestExpiredTimeInSecond;
      isCountDownTime = true;

    }
  }

  Future<void> asyncInit() async {
    _sharedPrefsHelper = SharedPreferenceHelper(await SharedPreferences.getInstance());
    if(widget.userStoreController.phoneController.isNotEmpty){
      final bool? result = await telephony.requestPhoneAndSmsPermissions;

      if (result != null && result) {
        telephony.listenIncomingSms(
          onNewMessage: this.handleSmsMessage,
          listenInBackground: false,
        );
      }
    }
  }

  handleSmsMessage(SmsMessage message) {
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
        widget.userStoreController.verifyCodeInput.value = otp;
        widget.userStoreController.isEnabledSubmitRegisterBtn.value = true;
      }
    }
  }

  onBackgroundMessage(SmsMessage message) {
    debugPrint("onBackgroundMessage called");
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 80.h),
        Text("register_type_text_step_2".tr + formatAddress(widget.userStoreController), style: TextUtils.textStyle(FontWeight.w600, 14.sp, color: AppColors.suvaGrey),),
        TextFieldWidget(
              filled: true,
              contentPadding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
              fillColor: Color.fromRGBO(246, 246, 246, 1),
              inputType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              maxLength: 6,
              hint: ('register_verify_code_hint').tr,
              padding: EdgeInsets.only(top: 16.0.h),
              prefixIcon: Icon(
                CustomIcons.shield_check,
                color: Colors.black26,
                size: 16,
              ),
              suffixIcon: Container(
                margin: EdgeInsets.only(right: 3.w),
                child: GestureDetector(
                  child: TextButton(
                      child: CountdownTimer(
                        endTime: endTime.value,
                        widgetBuilder: (_, time) {
                          if (time == null) {
                            isCountDownTime = false;
                            return Text(('register_resend_otp').tr,
                                style: TextStyle(color: AppColors.pink[500]));
                          }
                          return Text(('register_second').trParams({'param': '${time.sec}'}),
                              style: TextStyle(color: AppColors.whiteSmoke));
                        },
                      ),
                      onPressed: () async {
                            if (isCountDownTime == false) {
                              final gotOtp = await widget.userStoreController.getOtp();
                              gotOtp.fold((failure) {
                                _handleReceiveOtpFailure(failure);
                              }, (res) {
                                endTime.value = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
                                _handleReceiveOtpSuccess(res);
                              });
                            }
                      }),
                ),
              ),
              textController: _otpController,
              errorText: null,
              onChanged: (value) {
                widget.userStoreController.verifyCodeInput.value = _otpController.text;
                widget.userStoreController.enabledSubmitRegisterBtn();
              },
            ),
      ],
    ));
  }

  String formatAddress(UserStoreController userStoreController){
    String text = '';
    if(userStoreController.phoneController.value.isNotEmpty){
      text = userStoreController.phoneController.value.formatPhoneVerify();
    } else {
      text = userStoreController.emailController.value.formatEmailVerify();
    }
    return text;
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}
