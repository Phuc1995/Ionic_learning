import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:user_management/presentation/widgets/phonefield_widget.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserIdField extends StatefulWidget {
  final SharedPreferenceHelper sharedPrefsHelper;
  final TextEditingController textController;
  final UserStoreController userStoreController;

  // final UserStore? store ;
  const UserIdField({Key? key, required this.sharedPrefsHelper, required this.userStoreController, required this.textController})
      : super(key: key);

  @override
  _UserIdFieldState createState() => _UserIdFieldState();
}

class _UserIdFieldState extends State<UserIdField> {
  late FocusNode _idFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _idFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return widget.userStoreController.loginWithPhone.value
          ? PhoneFieldWidget(
            focusNode: _idFocusNode,
            textController: widget.textController,
            style: TextUtils.textStyle(FontWeight.w600, 18.sp, color: Colors.black),
            filled: true,
            contentPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
            autoFocus: false,
            inputAction: TextInputAction.next,
            onChanged: (value) {
              widget.sharedPrefsHelper.setFormPhoneCode(value.countryCode??'');
              widget.sharedPrefsHelper.setFormPhone(value.number??'');
              widget.userStoreController.phoneCodeController.value = value.countryCode??'';
              widget.userStoreController.phoneController.value = value.number??'';
              widget.userStoreController.invalidEmailMsg.value = '';
            },
            errorText: widget.userStoreController.invalidEmailMsg.value,
            errorStyle: TextUtils.textStyle(FontWeight.normal, 12, color: Color(0xFFFFE947)),
          )
          : TextFieldWidget(
            focusNode: _idFocusNode,
            style: TextUtils.textStyle(FontWeight.w600, 18.sp, color: Colors.black),
            filled: true,
            contentPadding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
            fillColor: Colors.white,
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
            errorText: widget.userStoreController.invalidEmailMsg.value == ''
                ? null
                : widget.userStoreController.invalidEmailMsg.value,
            errorStyle: TextStyle(color: Color(0xFFFFE947)),
            autoFocus: false,
            onChanged: (value) {
              widget.sharedPrefsHelper.setFormEmail(widget.textController.text);
              widget.userStoreController.emailController.value = widget.textController.text;
              widget.userStoreController.invalidEmailMsg.value = '';
            },
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.textController.dispose();
    _idFocusNode.dispose();
    super.dispose();
  }
}
