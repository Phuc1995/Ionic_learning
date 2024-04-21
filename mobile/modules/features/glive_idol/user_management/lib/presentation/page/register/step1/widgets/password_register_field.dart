import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordRegisterField extends StatefulWidget {
  final UserStoreController userStoreController;
  final TextEditingController passwordController;

  const PasswordRegisterField(
      {Key? key,
      required this.userStoreController,
      required this.passwordController})
      : super(key: key);

  @override
  _PasswordRegisterFieldState createState() => _PasswordRegisterFieldState();
}

class _PasswordRegisterFieldState extends State<PasswordRegisterField> {
  // TextEditingController _passwordController = TextEditingController();
  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;

  var _hidePassword = true.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFieldWidget(
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
        fillColor: Color.fromRGBO(246, 246, 246, 1),
        maxLength: 50,
        hint: ('login_et_user_password').tr,
        isObscure: _hidePassword.value,
        padding: EdgeInsets.only(top: 16.0.h),
        prefixIcon: Icon(
          CustomIcons.lock,
          color: Colors.black26,
          size: 16.sp,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            _hidePassword.value = !_hidePassword.value;
          },
          child: Icon(
            _hidePassword.value ? Icons.visibility : Icons.visibility_off,
            color: Colors.black26,
          ),
        ),
        textController: widget.passwordController,
        focusNode: _passwordFocusNode,
        errorText: null,
        onChanged: (value) {
          widget.userStoreController.passwordController.value =
              widget.passwordController.text;
          widget.userStoreController.enabledStep1Button();
        },
      ),
    );
  }
}
