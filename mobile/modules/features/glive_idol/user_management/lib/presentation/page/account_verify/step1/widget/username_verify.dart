import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:user_management/presentation/controller/user/account_verify_store_controller.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsernameVerify extends StatefulWidget {
  final AccountVerifyStoreController accountVerifyStoreController;
  const UsernameVerify({Key? key, required this.accountVerifyStoreController}) : super(key: key);

  @override
  _UsernameVerifyState createState() => _UsernameVerifyState();
}

class _UsernameVerifyState extends State<UsernameVerify> {

  TextEditingController _usernameController = TextEditingController();
  final logger = Modular.get<Logger>();
  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      style: TextUtils.textStyle(FontWeight.w600, 18.sp,color: AppColors.suvaGrey),
      textController: _usernameController,
      inputType: TextInputType.text,
      inputAction: TextInputAction.next,
      autoFocus: false,
      hint: ('account_verify_username').tr,
      filled: true,
      maxLength: 50,
      contentPadding: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 20.h),
      fillColor: Color(0xFFF6F6F6),
      validator: validateUsername,
      onChanged: (value){
        widget.accountVerifyStoreController.fullNameController.value = value;
      },
    );
  }

  String? validateUsername(value) {
    if (StringValidate.isEmpty(value)) {
      return ('account_verify_username_empty').tr;
    }
    if (!StringValidate.isAlphabets(value)) {
      return ('account_verify_username_not_alphabets').tr;
    }
    return null;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}

