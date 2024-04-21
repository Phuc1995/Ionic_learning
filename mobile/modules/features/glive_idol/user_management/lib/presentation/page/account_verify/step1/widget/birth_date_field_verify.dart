import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_management/presentation/controller/user/account_verify_store_controller.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BirthDateVerify extends StatefulWidget {
  const BirthDateVerify({Key? key}) : super(key: key);

  @override
  _BirthDateVerifyState createState() => _BirthDateVerifyState();
}

class _BirthDateVerifyState extends State<BirthDateVerify> {
  TextEditingController _birthdateController = TextEditingController();
  final df = new DateFormat('dd-MM-yyyy');
  final AccountVerifyStoreController _accountVerifyStoreController =  Get.put(AccountVerifyStoreController());
  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      textController: _birthdateController,
      inputType: TextInputType.datetime,
      hint: ('account_verify_birth_date').tr,
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 20.h),
      fillColor: Color(0xFFF6F6F6),
      onTap: () async {
        DateTime? nowDate = DateTime.now();
        DateTime? date = new DateTime(nowDate.year - 18, nowDate.month, nowDate.day);
        FocusScope.of(context).requestFocus(new FocusNode());
        date = await showDatePicker(
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            initialDate: _birthdateController.text != ''
                ? DateFormat('dd-MM-yyyy').parse(_birthdateController.text)
                : new DateTime(nowDate.year - 18, nowDate.month, nowDate.day),
            firstDate: DateTime(1900, 1, 1),
            lastDate: new DateTime(nowDate.year - 18, nowDate.month, nowDate.day));
        _birthdateController.text = df.format(date!);
        var inputFormat = DateFormat("dd-MM-yyyy");
        var birthdate = inputFormat.parse(_birthdateController.text);
        _accountVerifyStoreController.birthdateController.value =  DateFormat('yyyy-MM-dd').parse('$birthdate').toString();
      },
      validator: validateBirthdate,
    );
  }

  String? validateBirthdate(value) {
    if (value == null || value.isEmpty) {
      return ('account_verify_birthdate_empty').tr;
    }
    return null;
  }

  @override
  void dispose() {
    _birthdateController.dispose();
    super.dispose();
  }
}
