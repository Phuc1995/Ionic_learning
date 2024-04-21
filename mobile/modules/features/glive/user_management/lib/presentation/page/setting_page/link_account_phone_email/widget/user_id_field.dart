import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:user_management/controllers/link_account_store_controller.dart';
import 'package:user_management/presentation/widgets/phonefield_widget.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PhoneEmailFiled extends StatefulWidget {
  final TextEditingController textController;
  final LinkAccountStoreController storeController;

  const PhoneEmailFiled({Key? key, required this.storeController, required this.textController}) : super(key: key);

  @override
  _PhoneEmailFiledState createState() => _PhoneEmailFiledState();
}

class _PhoneEmailFiledState extends State<PhoneEmailFiled> {

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => widget.storeController.isPhone.value
          ? PhoneFieldWidget(
        textController: widget.textController,
        style: TextUtils.textStyle(FontWeight.w600, 18.sp,
            color: Colors.black),
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
        autoFocus: false,
        inputAction: TextInputAction.next,
        onChanged: (value) {
          widget.storeController.phoneCodeController.value =
              value.countryCode ?? '';
          widget.storeController.phoneController.value =
              value.number ?? '';
          widget.storeController.invalidEmailMsg.value = '';
        },
        errorText: widget.storeController.invalidEmailMsg.value,
        errorStyle: TextUtils.textStyle(FontWeight.normal, 12,
            color: Color(0xFFFF0000)),
      ) : TextFieldWidget(
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
        fillColor: AppColors.whiteSmoke3,
        maxLength: 60,
        hint: 'link_account_email_hint'.tr,
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
        errorText: widget.storeController.invalidEmailMsg.value == ''
            ? null
            : widget.storeController.invalidEmailMsg.value,
        errorStyle: TextStyle(color: Colors.red),
        autoFocus: false,
        onChanged: (value) {
          widget.storeController.emailController.value = widget.textController.text;
          widget.storeController.invalidEmailMsg.value = '';
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
