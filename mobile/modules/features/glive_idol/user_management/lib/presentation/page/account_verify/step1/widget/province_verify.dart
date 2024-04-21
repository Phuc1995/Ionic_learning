import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/presentation/controller/user/account_verify_store_controller.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProvinceVerify extends StatefulWidget {
  final AccountVerifyStoreController accountVerifyStoreController;
  const ProvinceVerify({Key? key, required this.accountVerifyStoreController}) : super(key: key);

  @override
  _ProvinceVerifyState createState() => _ProvinceVerifyState();
}

class _ProvinceVerifyState extends State<ProvinceVerify> {
  TextEditingController _provinceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      style: TextUtils.textStyle(FontWeight.w600, 18.sp,color: AppColors.suvaGrey),
      textController: _provinceController,
      inputType: TextInputType.text,
      inputAction: TextInputAction.next,
      autoFocus: false,
      hint: ('account_verify_province').tr,
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 20.h),
      fillColor: Color(0xFFF6F6F6),
      maxLength: 50,
      validator: validateProvince,
      onChanged: (value){
        widget.accountVerifyStoreController.provinceController.value = value;
      },
    );
  }

  String? validateProvince(value) {
    if (StringValidate.isEmpty(value)) {
      return ('account_verify_province_empty').tr;
    }
    if (!StringValidate.isAlphabetsComma(value)) {
      return ('account_verify_username_not_alphabets').tr;
    }
    return null;
  }

  @override
  void dispose() {
    _provinceController.dispose();
    super.dispose();
  }
}
