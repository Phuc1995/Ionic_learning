import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/account_complete_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenderRadioButton extends StatelessWidget {
  final AccountCompleteController  accountCompleteController;
  const GenderRadioButton({Key? key, required this.accountCompleteController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic _activeGenderButton = {
      true: {'background': Color(0xFF444444), 'textColor': Colors.white},
      false: {'background': Color(0xFFF6F6F6), 'textColor': Color(0xFF8A8A8A)}
    };
    return Row(
      children: [
        Obx(() => Expanded(
          child: _textGenderButton(_activeGenderButton[accountCompleteController.genderController.value == 0],
              ('account_verify_female').tr, Icons.female, 0),
        ),),
        SizedBox(width: 15),
        Obx(() => Expanded(
          child: _textGenderButton(_activeGenderButton[accountCompleteController.genderController.value == 1],
            ('account_verify_male').tr, Icons.male, 1, ),
        ),),
        SizedBox(width: 15),
        Obx(() => Expanded(
          child: _textGenderButton(_activeGenderButton[accountCompleteController.genderController.value == 2],
            ('account_verify_other').tr, Icons.male, 2, ),
        ),)
      ],
    );

  }

  Widget _textGenderButton(Map<String, Color> color, String gender, icon, int enumGender) {
    return RoundedButtonWidget(
      buttonColor: color['background'] ?? Colors.white,
      buttonText: gender,
      onPressed: (){
        accountCompleteController.genderController.value = enumGender;
      },
      textColor: color['textColor'] ?? Colors.white,
      icon: icon,
      height: 57.h,
    );
  }


}
