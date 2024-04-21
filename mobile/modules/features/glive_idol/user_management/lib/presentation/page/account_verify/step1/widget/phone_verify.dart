import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/presentation/controller/user/account_verify_store_controller.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneVerify extends StatefulWidget {
  final AccountVerifyStoreController accountVerifyStoreController;
  const PhoneVerify({Key? key, required this.accountVerifyStoreController}) : super(key: key);

  @override
  _PhoneVerifyState createState() => _PhoneVerifyState();
}

class _PhoneVerifyState extends State<PhoneVerify> {
  TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      style: TextUtils.textStyle(FontWeight.w600, 18.sp,color: AppColors.suvaGrey),
      textController: _phoneController,
      inputType: TextInputType.phone,
      inputAction: TextInputAction.next,
      autoFocus: false,
      hint: ('account_verify_phone').tr,
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 20.h),
      fillColor: Color(0xFFF6F6F6),
      maxLength: 10,
      validator: validatePhone,
      onChanged: (value){
        widget.accountVerifyStoreController.mobileController.value = value;
      },
    );
  }

  String? validatePhone(value) {
    if (StringValidate.isEmpty(value)) {
      return ('account_verify_phone_empty').tr;
    } else if (!StringValidate.isPhoneNumber(value)) {
      return ('account_verify_phone_format').tr;
    }
    return null;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
