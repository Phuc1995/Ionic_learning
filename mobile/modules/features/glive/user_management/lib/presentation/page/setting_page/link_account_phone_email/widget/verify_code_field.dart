import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:telephony/telephony.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/dto/otp_dto.dart';
import 'package:user_management/controllers/link_account_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyCodeField extends StatefulWidget {
  final LinkAccountStoreController storeController;

  const VerifyCodeField({Key? key, required this.storeController}) : super(key: key);

  @override
  _VerifyCodeFieldState createState() => _VerifyCodeFieldState();
}

class _VerifyCodeFieldState extends State<VerifyCodeField> {
  UserStoreController _userStoreController = Get.put(UserStoreController());
  final telephony = Telephony.instance;
  TextEditingController _verifyCodeController = TextEditingController();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 0;
  bool isCountDownTime = true;
  ShowErrorMessage showErrorMessage = ShowErrorMessage();
  late Future<void> _initializeControllerFuture;
  bool firstOtp = true;

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
        widget.storeController.verifyController.value = otp;
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
      hint: 'link_account_otp_hint'.tr,
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
                  return Text(firstOtp ? 'link_account_send'.tr : 'link_account_resend'.tr,
                      style: TextStyle(
                        color: AppColors.pink[500],
                      ));
                }

                return Text('( ' + time.sec.toString() + 'link_account_seconds'.tr + ' )',
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
      errorText: widget.storeController.invalidVerifyMsg.value != ''
          ? widget.storeController.invalidVerifyMsg.value
          : null,
      errorStyle: TextStyle(color: Colors.red),
      onChanged: (value) {
        widget.storeController.verifyController.value = _verifyCodeController.text;
        widget.storeController.invalidVerifyMsg.value = '';
      },
    ),);
  }

  Future<void> requestOTP() async {
    if (widget.storeController.isPhone.value) {
      String error = widget.storeController.validatePhone(context);
      if (error.isNotEmpty) {
        showErrorMessage.show(
          message: error,
          context: context,
        );
        return;
      }
    } else {
      String error = widget.storeController.validateEmail(context);
      if (error.isNotEmpty) {
        showErrorMessage.show(
          message: error,
          context: context,
        );
        return;
      }
    }
    CheckExistingUserParamsDto params = CheckExistingUserParamsDto(
      email: widget.storeController.emailController.value,
      phoneCode: widget.storeController.phoneCodeController.value,
      phone: widget.storeController.phoneController.value,
      loginWithPhone: widget.storeController.isPhone.value,
    );
    widget.storeController.isLoading.value = true;
    final userExist =  await _userStoreController.checkExistingUser(params);
    userExist.fold((failure) {
      widget.storeController.isLoading.value = false;
      if(failure is NetworkFailure){
        ShowShortMessage().showTop(context: context, message: "no_network".tr);
      }
      if (failure is DioFailure) {
        String errMessage = 'link_account_get_otp_error_unknown'.tr;
        showErrorMessage.show(
          message: errMessage,
          context: context,
        );
      }
    }, (isExit) async {
      DeviceUtils.hideKeyboard(context);
      if(isExit){
        widget.storeController.isLoading.value = false;
        showErrorMessage.show(context: context, message: widget.storeController.isPhone.value ? 'link_account_existed_phone'.tr : "link_account_existed_email".tr);
      } else {
        // If countdown time is running
        if (isCountDownTime == true) {
          return;
        }

        // end: If countdown time is running
        OtpDto requestOtpParams = new OtpDto();
        requestOtpParams.type = 'link';
        requestOtpParams.email = widget.storeController.emailController.value;
        if (widget.storeController.isPhone.value) {
          requestOtpParams = new OtpDto(
            type: 'link',
            phoneCode: widget.storeController.phoneCodeController.toString(),
            phoneNumber:  widget.storeController.phoneController.toString(),
          );
        }
        final otp = await widget.storeController.getOtp(requestOtpParams);

        otp.fold((failure) {
          widget.storeController.isLoading.value = false;
          if (failure is DioFailure) {
            showErrorMessage.show(
              message: 'link_account_get_otp_error_unknown'.tr,
              context: context,
            );
            return;
          }
        }, (GatewayResponse) {
          widget.storeController.isLoading.value = false;
          if (GatewayResponse.messageCode == MessageCode.SEND_OTP_SUCCESS) {
            setState(() {
              int requestExpiredTimeInSecond = GatewayResponse.data['requestExpiredTimeInSecond'] ?? 60;
              endTime = DateTime.now().millisecondsSinceEpoch + 1000 * requestExpiredTimeInSecond;
              isCountDownTime = true;
              firstOtp = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _verifyCodeController.dispose();
    super.dispose();
  }
}
