import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/domain/usecase/skills/update_skills_idol.dart';
import 'package:user_management/presentation/controller/skills/skills_controller.dart';

class LiveButton extends StatelessWidget {
  const LiveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SkillsController _skillsController = Get.put(SkillsController());
    return Container(
      padding: EdgeInsets.only(top: 16.0.h),
      child: RoundedButtonGradientWidget(
          height: 48.h,
          textSize: 16.sp,
          buttonText: 'account_verify_complete_button'.tr,
          buttonColor: AppColors.pinkGradientButton,
          textColor: Colors.white,
          onPressed: () {
                List skills = <String>[];
                _skillsController.listAllSkills.forEach((element) {
                  if(element.isCheck){
                    skills.add(element.key);
                  }
                });
                UpdateSkillsIdol().call(skills.join("#").toString());
                Modular.to.navigate(IdolRoutes.user_management.home);
          }
    ),
    );
  }
}
