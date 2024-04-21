import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/controllers/reset_password_store_controller.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewPasswordField extends StatefulWidget {
  final ResetPasswordStoreController resetPasswordStoreController;

  const NewPasswordField({Key? key, required this.resetPasswordStoreController}) : super(key: key);

  @override
  _NewPasswordFieldFieldState createState() => _NewPasswordFieldFieldState();
}

class _NewPasswordFieldFieldState extends State<NewPasswordField> {
  TextEditingController _passwordController = TextEditingController();
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

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
          hint: 'forgot_password_new'.tr,
          isObscure: !widget.resetPasswordStoreController.showPassword.value,
          prefixIcon: Icon(CustomIcons.lock, color: Colors.black26, size: 16),
          suffixIcon: GestureDetector(
            onTap: () {
              widget.resetPasswordStoreController.showPassword.value =
                  !widget.resetPasswordStoreController.showPassword.value;
            },
            child: Icon(
              widget.resetPasswordStoreController.showPassword.value
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: Colors.black26,
            ),
          ),
          textController: _passwordController,
          focusNode: _passwordFocusNode,
          errorText: widget.resetPasswordStoreController.invalidPasswordMsg.value == ''
              ? null
              : widget.resetPasswordStoreController.invalidPasswordMsg.value,
          errorStyle: TextStyle(color: Colors.red),
          onChanged: (value) {
            widget.resetPasswordStoreController.passwordController.value = _passwordController.text;
            widget.resetPasswordStoreController.invalidPasswordMsg.value = '';
          },
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
