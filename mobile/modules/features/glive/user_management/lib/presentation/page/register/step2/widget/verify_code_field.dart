import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:telephony/telephony.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:user_management/controllers/user_store_controller.dart';
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

  TextEditingController _otpController = TextEditingController();
  late Future<void> _initializeControllerFuture;
  var endTime = (DateTime.now().millisecondsSinceEpoch + 1000 * 60).obs;
  bool isCountDownTime = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeControllerFuture = Future.wait([asyncInit()]);

    widget.userStoreController.getOtp().then((data) {
      data.fold((failure) {
        widget.userStoreController.handleReceiveOtpFailure(failure, context);
      }, (res) {
        widget.userStoreController.handleReceiveOtpSuccess(res, isCountDownTime, endTime);
      });
    });
  }



  Future<void> asyncInit() async {
    if(widget.userStoreController.phoneController.value.isNotEmpty){
      final bool? result = await telephony.requestPhoneAndSmsPermissions;
      if (result != null && result) {
        telephony.listenIncomingSms(
          onNewMessage: (message){
            widget.userStoreController.handleSmsMessage(message, _otpController);
          },
          listenInBackground: false,
        );
      }
    }
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
              autofillHints: const <String>[AutofillHints.oneTimeCode],
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              maxLength: 6,
              hint: ('register_verify_code_hint').tr,
              style: TextUtils.textStyle(FontWeight.w600, 18.sp, color: Colors.black),
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
                            widget.userStoreController.handleReceiveOtpFailure(failure, context);
                          }, (res) {
                            endTime.value = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
                            widget.userStoreController.handleReceiveOtpSuccess(res, isCountDownTime, endTime);
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
