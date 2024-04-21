import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:user_management/presentation/widgets/phonefield_widget.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserIdFieldRegister extends StatefulWidget {
  final UserStoreController userStoreController;
  final TextEditingController textController;
  final SharedPreferenceHelper sharedPrefsHelper;

  const UserIdFieldRegister({Key? key, required this.sharedPrefsHelper, required this.userStoreController, required this.textController})
      : super(key: key);

  @override
  _UserIdFieldRegisterState createState() => _UserIdFieldRegisterState();
}

class _UserIdFieldRegisterState extends State<UserIdFieldRegister> {
  final logger = Modular.get<Logger>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return widget.userStoreController.loginWithPhone.value
          ? PhoneFieldWidget(
        textController: widget.textController,
        style: TextUtils.textStyle(FontWeight.w600, 18.sp,
            color: Colors.black),
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
        autoFocus: false,
        inputAction: TextInputAction.next,
        onChanged: (value) {
          widget.sharedPrefsHelper.setFormPhoneCode(value.countryCode??'');
          widget.sharedPrefsHelper.setFormPhone(value.number??'');
          widget.userStoreController.phoneCodeController.value =
              value.countryCode ?? '';
          widget.userStoreController.phoneController.value =
              value.number ?? '';
          widget.userStoreController.invalidEmailMsg.value = '';
          widget.userStoreController.enabledStep1Button();
        },
        errorText: widget.userStoreController.invalidEmailMsg.value,
        errorStyle: TextUtils.textStyle(FontWeight.normal, 12,
            color: Color(0xFFFF0000)),
      )
          : TextFieldWidget(
        style: TextUtils.textStyle(FontWeight.w600, 18.sp, color: Colors.black),
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
        fillColor: Color.fromRGBO(246, 246, 246, 1),
        maxLength: 60,
        hint: ('login_et_user_email').tr,
        padding: EdgeInsets.only(top: 16.0.h),
        prefixIcon: Icon(
          CustomIcons.mail,
          color: Colors.black26,
          size: 16.sp,
        ),
        textController: widget.textController,
        inputType: TextInputType.emailAddress,
        errorText: widget.userStoreController.invalidEmailMsg.value == ''
            ? null
            : widget.userStoreController.invalidEmailMsg.value,
        errorStyle: TextStyle(color: Color(0xFFFF0000)),
        onChanged: (value) {
          widget.sharedPrefsHelper.setFormEmail(widget.textController.text);
          widget.userStoreController.emailController.value =
              widget.textController.text;
          widget.userStoreController.invalidEmailMsg.value = '';
          widget.userStoreController.enabledStep1Button();
        },
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
