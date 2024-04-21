import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:telephony/telephony.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:user_management/domain/entity/request/otp.dart';
import 'package:user_management/domain/usecase/auth/check_existing_user.dart';
import 'package:user_management/domain/usecase/auth/reset_password.dart';
import 'package:user_management/presentation/controller/user/reset_password_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyCodeField extends StatefulWidget {
  final ResetPasswordStoreController resetPasswordStoreController;

  const VerifyCodeField({Key? key, required this.resetPasswordStoreController}) : super(key: key);

  @override
  _VerifyCodeFieldState createState() => _VerifyCodeFieldState();
}

class _VerifyCodeFieldState extends State<VerifyCodeField> {
  final telephony = Telephony.instance;
  TextEditingController _verifyCodeController = TextEditingController();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 0;
  bool isCountDownTime = true;
  ShowErrorMessage showErrorMessage = ShowErrorMessage();
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = Future.wait([asyncInit()]);
  }

  Future<void> asyncInit() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
        onNewMessage: this.handleSmsMessage,
        listenInBackground: false,
      );
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
        _verifyCodeController.text = otp;
        widget.resetPasswordStoreController.verifyController.value = otp;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFieldWidget(
      filled: true,
      inputType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      contentPadding: EdgeInsets.fromLTRB(16.w, 16.h, 32.w, 16.h),
      maxLength: 6,
      hint: 'forgot_password_hint_send_otp'.tr,
      prefixIcon: Icon(
        CustomIcons.shield_check,
        color: Colors.black26,
        size: 16.sp,
      ),
      suffixIcon: GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: TextButton(
            child: CountdownTimer(
              endTime: endTime,
              onEnd: () {
                _verifyCodeController.text = '';
              },
              widgetBuilder: (_, time) {
                if (time == null) {
                  isCountDownTime = false;
                  return Text('forgot_password_send_otp'.tr,
                      style: TextStyle(
                        color: AppColors.pink[500],
                      ));
                }

                return Text('( ' + time.sec.toString() + 'forgot_password_second'.tr + ' )',
                    style: TextStyle(
                      color: AppColors.whiteSmoke,
                    ));
              },
            ),
            onPressed: requestOTP,
          ),
        ),
      ),
      textController: _verifyCodeController,
      autoFocus: false,
      errorText: widget.resetPasswordStoreController.invalidVerifyMsg.value != ''
          ? widget.resetPasswordStoreController.invalidVerifyMsg.value
          : null,
      errorStyle: TextStyle(color: Colors.red),
      onChanged: (value) {
        widget.resetPasswordStoreController.verifyController.value = _verifyCodeController.text;
        widget.resetPasswordStoreController.invalidVerifyMsg.value = '';
      },
    ),);
  }

  Future<void> requestOTP() async {
        if (widget.resetPasswordStoreController.loginWithPhone.value) {
          String error = widget.resetPasswordStoreController.validatePhone(context);
          if (error.isNotEmpty) {
            showErrorMessage.show(
              message: error,
              context: context,
            );
            return;
          }
        } else {
          String error = widget.resetPasswordStoreController.validateEmail(context);
          if (error.isNotEmpty) {
            showErrorMessage.show(
              message: error,
              context: context,
            );
            return;
          }
        }
        CheckExistingUserParams params = CheckExistingUserParams(
          email: widget.resetPasswordStoreController.emailController.value,
          phoneCode: widget.resetPasswordStoreController.phoneCodeController.value,
          phone: widget.resetPasswordStoreController.phoneController.value,
          loginWithPhone: widget.resetPasswordStoreController.loginWithPhone.value,
        );
        final userExist =
        await CheckExistingUserResetPassword().call(params);
        userExist.fold((failure) {
          if (failure is DioFailure) {
            String errMessage = 'forgot_password_get_otp_error_unknown'.tr;
            if (failure.statusCode == 401 || failure.statusCode == 400) {
              errMessage = widget.resetPasswordStoreController.loginWithPhone.value ? 'forgot_password_phone_not_exist'.tr :'forgot_password_email_not_exist'.tr;
            }
            showErrorMessage.show(
              message: errMessage,
              context: context,
            );
            return;
          }
        }, (GatewayResponse) async {
          if (GatewayResponse.messageCode == MessageCode.USER_NOT_EXIST) {
            showErrorMessage.show(
              message: widget.resetPasswordStoreController.loginWithPhone.value ? 'forgot_password_phone_not_exist'.tr : 'forgot_password_email_not_exist'.tr,
              context: context,
            );
          } else {
            // If countdown time is running
            if (isCountDownTime == true) {
              return;
            }

            // end: If countdown time is running
            OtpDto requestOtpParams = new OtpDto();
            requestOtpParams.type = "email";
            requestOtpParams.email = widget.resetPasswordStoreController.emailController.value;
            if (widget.resetPasswordStoreController.loginWithPhone.value) {
              requestOtpParams = new OtpDto(
                type: 'sms',
                phoneCode: widget.resetPasswordStoreController.phoneCodeController.toString(),
                phoneNumber:  widget.resetPasswordStoreController.phoneController.toString(),
              );
            }
            final otp = await GetOtpResetPassword().call(requestOtpParams);

            otp.fold((failure) {
              if (failure is DioFailure) {
                showErrorMessage.show(
                  message: 'forgot_password_get_otp_error_unknown'.tr,
                  context: context,
                );
                return;
              }
            }, (GatewayResponse) {
              if (GatewayResponse.messageCode == MessageCode.SEND_OTP_SUCCESS) {
                setState(() {
                  int requestExpiredTimeInSecond = GatewayResponse.data['requestExpiredTimeInSecond'] ?? 60;
                  endTime = DateTime.now().millisecondsSinceEpoch + 1000 * requestExpiredTimeInSecond;
                  isCountDownTime = true;
                });
              }
            });
          }
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _verifyCodeController.dispose();
    super.dispose();
  }
}
