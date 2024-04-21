import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordInputField extends StatelessWidget {
  final RxString passwordController;
  final RxBool showPassword;
  final RxString invalidPasswordMsg;
  final String hint;
  PasswordInputField({
    Key? key,
    required this.passwordController,
    required this.showPassword,
    required this.invalidPasswordMsg,
    required this.hint,
  }) : super(key: key);

  TextEditingController _passwordController = TextEditingController();
  FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFieldWidget(
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          filled: true,
          autoFocus: false,
          padding: EdgeInsets.only(top: 16.0.h),
          contentPadding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
          fillColor: AppColors.whiteSmoke3,
          maxLength: 50,
          hint: hint,
          isObscure: !showPassword.value,
          prefixIcon: Icon(CustomIcons.lock, color: Colors.black26, size: 16),
          suffixIcon: GestureDetector(
            onTap: () {
              showPassword.value = !showPassword.value;
            },
            child: Icon(
              showPassword.value
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: Colors.black26,
            ),
          ),
          textController: _passwordController,
          focusNode: _passwordFocusNode,
          errorText: invalidPasswordMsg.value == ''
              ? null
              : invalidPasswordMsg.value,
          errorStyle: TextStyle(color: Colors.red),
          onChanged: (value) {
            passwordController.value = _passwordController.text;
            value = '';
          },
        )
    );
  }
}
