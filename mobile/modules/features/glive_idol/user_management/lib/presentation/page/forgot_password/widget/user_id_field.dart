import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:user_management/presentation/controller/user/reset_password_store_controller.dart';
import 'package:user_management/presentation/widgets/phonefield_widget.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class UserIdFiled extends StatefulWidget {
  final ResetPasswordStoreController resetPasswordStoreController;
  final TextEditingController textController;
  final SharedPreferenceHelper sharedPrefsHelper;

  const UserIdFiled({Key? key, required this.resetPasswordStoreController, required this.textController, required this.sharedPrefsHelper}) : super(key: key);

  @override
  _UserIdFiledState createState() => _UserIdFiledState();
}

class _UserIdFiledState extends State<UserIdFiled> {

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => widget.resetPasswordStoreController.loginWithPhone.value
          ? PhoneFieldWidget(
        textController: widget.textController,
        style: TextUtils.textStyle(FontWeight.w600, 18.sp,
            color: Colors.black),
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
        autoFocus: false,
        inputAction: TextInputAction.next,
        onChanged: (value) {
          widget.resetPasswordStoreController.phoneCodeController.value =
              value.countryCode ?? '';
          widget.resetPasswordStoreController.phoneController.value =
              value.number ?? '';
          widget.resetPasswordStoreController.invalidEmailMsg.value = '';
        },
        errorText: widget.resetPasswordStoreController.invalidEmailMsg.value,
        errorStyle: TextUtils.textStyle(FontWeight.normal, 12,
            color: Color(0xFFFF0000)),
      ) : TextFieldWidget(
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
        fillColor: AppColors.whiteSmoke3,
        maxLength: 60,
        hint: 'login_et_user_email'.tr,
        isObscure: false,
        inputAction: TextInputAction.next,
        padding: EdgeInsets.only(top: 16.0.h),
        prefixIcon: Icon(
          CustomIcons.mail,
          color: Colors.black26,
          size: 16.sp,
        ),
        inputType: TextInputType.emailAddress,
        textController: widget.textController,
        errorText: widget.resetPasswordStoreController.invalidEmailMsg.value == ''
            ? null
            : widget.resetPasswordStoreController.invalidEmailMsg.value,
        errorStyle: TextStyle(color: Colors.red),
        autoFocus: false,
        onChanged: (value) {
          widget.resetPasswordStoreController.emailController.value = widget.textController.text;
          widget.resetPasswordStoreController.invalidEmailMsg.value = '';
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
