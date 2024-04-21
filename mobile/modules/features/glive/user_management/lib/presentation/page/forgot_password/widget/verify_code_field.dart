import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:telephony/telephony.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/dto/otp_dto.dart';
import 'package:user_management/controllers/reset_password_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/service/auth_api_service.dart';

class VerifyCodeField extends StatefulWidget {
  final ResetPasswordStoreController resetPasswordStoreController;

  const VerifyCodeField({Key? key, required this.resetPasswordStoreController}) : super(key: key);

  @override
  _VerifyCodeFieldState createState() => _VerifyCodeFieldState();
}

class _VerifyCodeFieldState extends State<VerifyCodeField> {
  final telephony = Telephony.instance;
  TextEditingController _verifyCodeController = TextEditingController();



  late Future<void> _initializeControllerFuture;
  final _authService = Modular.get<AuthApiService>();

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = Future.wait([asyncInit()]);
  }

  Future<void> asyncInit() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;
    if (result != null && result) {
      telephony.listenIncomingSms(
        onNewMessage: (smsMessage){
          widget.resetPasswordStoreController.handleSmsMessage(smsMessage, _verifyCodeController);
        },
        listenInBackground: false,
      );
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
      style: TextUtils.textStyle(FontWeight.w600, 18.sp, color: Colors.black),
      prefixIcon: Icon(
        CustomIcons.shield_check,
        color: Colors.black26,
        size: 16.sp,
      ),
      suffixIcon: GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: TextButton(
            child: Obx(() => CountdownTimer(
              endTime: widget.resetPasswordStoreController.endTime.value,
              onEnd: () {
                _verifyCodeController.text = '';
              },
              widgetBuilder: (_, time) {
                if (time == null) {
                  widget.resetPasswordStoreController.isCountDownTime.value = false;
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
            )),
            onPressed: () async {
              await widget.resetPasswordStoreController.requestOTP(context);
            },
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



  @override
  void dispose() {
    // TODO: implement dispose
    _verifyCodeController.dispose();
    super.dispose();
  }
}
