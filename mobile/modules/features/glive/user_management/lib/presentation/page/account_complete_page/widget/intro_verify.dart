import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/account_complete_controller.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntroVerify extends StatefulWidget {
  final AccountCompleteController accountCompleteController;
  const IntroVerify({Key? key, required this.accountCompleteController}) : super(key: key);

  @override
  _IntroVerifyState createState() => _IntroVerifyState();
}

class _IntroVerifyState extends State< IntroVerify> {
  TextEditingController _introController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      style: TextUtils.textStyle(FontWeight.w600, 18.sp,color: AppColors.suvaGrey),
      textController: _introController,
      inputType: TextInputType.text,
      autoFocus: false,
      hint: ('edit_user_info_intro').tr,
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 20.h),
      fillColor: Color(0xFFF6F6F6),
      maxLength: 50,
      onChanged: (value){
        widget.accountCompleteController.introController.value = value;
      },
    );
  }

  String? validateProvince(value) {
    if (StringValidate.isEmpty(value)) {
      return ('account_verify_intro_empty').tr;
    }
    return null;
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }
}
