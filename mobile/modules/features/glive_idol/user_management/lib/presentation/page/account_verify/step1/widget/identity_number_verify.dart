import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:user_management/presentation/controller/user/account_verify_store_controller.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IdentityNumberVerify extends StatefulWidget {
  final AccountVerifyStoreController accountVerifyStoreController;
  const IdentityNumberVerify({Key? key, required this.accountVerifyStoreController}) : super(key: key);

  @override
  _IdentityNumberVerifyState createState() => _IdentityNumberVerifyState();
}

class _IdentityNumberVerifyState extends State<IdentityNumberVerify> {
  TextEditingController _identityNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      style: TextUtils.textStyle(FontWeight.w600, 18.sp,color: AppColors.suvaGrey),
      textController: _identityNumberController,
      inputType: TextInputType.text,
      inputAction: TextInputAction.next,
      autoFocus: false,
      hint: ('account_verify_identity_number').tr,
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 20.h),
      fillColor: Color(0xFFF6F6F6),
      validator: validateIdentityNumber,
      maxLength: 12,
      onChanged: (value){
        widget.accountVerifyStoreController.identityNumberController.value = value;
      },
    );
  }

  String? validateIdentityNumber(value) {
    if (StringValidate.isEmpty(value)) {
      return ('account_verify_identity_number_empty').tr;
    }
    if(!StringValidate.isAlphabetsEN(value)){
      return "account_verify_username_not_alphabets".tr;
    }
    return null;
  }

  @override
  void dispose() {
    _identityNumberController.dispose();
    super.dispose();

  }
}

