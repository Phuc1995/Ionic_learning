import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordField extends StatefulWidget {
  final UserStoreController userStoreController;
  final TextEditingController passwordController;
  const PasswordField({Key? key, required this.userStoreController, required this.passwordController}) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=> TextFieldWidget(
      style: TextUtils.textStyle(FontWeight.w600, 18.sp, color: Colors.black),
      filled: true,
      autoFocus: false,
      padding: EdgeInsets.only(top: 16.0.h),
      contentPadding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      fillColor: Colors.white,
      maxLength: 255,
      hint: 'login_et_user_password'.tr,
      isObscure: !widget.userStoreController.showPassword.value,
      prefixIcon: Icon(CustomIcons.lock, color: Colors.black26, size: 16.sp),
      suffixIcon: GestureDetector(
        onTap: () {
          widget.userStoreController.showPassword.value = !widget.userStoreController.showPassword.value;
        },
        child: Icon(
          widget.userStoreController.showPassword.value ? Icons.visibility_off : Icons.visibility,
          color: Colors.black26,
          size: 24.sp,
        ),
      ),
      textController: widget.passwordController,
      errorText: widget.userStoreController.invalidPasswordMsg.value == '' ? null : widget.userStoreController.invalidPasswordMsg.value,
      errorStyle: TextUtils.textStyle(FontWeight.w400, 12.sp,color: Color(0xFFFFE947)),
      onChanged: (value) {
        widget.userStoreController.passwordController.value = widget.passwordController.text;
        widget.userStoreController.invalidPasswordMsg.value = '';
      },
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.passwordController.dispose();
    super.dispose();
  }
}

