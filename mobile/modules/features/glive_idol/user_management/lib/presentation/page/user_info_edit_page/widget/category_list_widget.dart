import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/presentation/controller/skills/skills_controller.dart';
import 'package:user_management/presentation/widgets/checkbox_button_widget.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SkillsController _skillsController = Get.put(SkillsController());
    String _storageUrl = Modular.get<SharedPreferenceHelper>().storageServer + '/' + Modular.get<SharedPreferenceHelper>().bucketName + '/';
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          Obx(()=> Wrap(
            children: List.generate(_skillsController.listAllSkills.length, (index) {
              return Obx(() => CheckboxButton(
                storageUrl: _storageUrl,
                item: _skillsController.listAllSkills[index],
                selected: _skillsController.listAllSkills[index].isCheck,
                onPressed: () {
                  int countSkillSelected = 0;
                  _skillsController.listAllSkills.forEach((ele) {
                    if(ele.isCheck == true) countSkillSelected = countSkillSelected + 1;
                  });
                  if((countSkillSelected < 3) || (countSkillSelected < 4 && _skillsController.listAllSkills[index].isCheck == true ) ){
                    _skillsController.listAllSkills[index].isCheck = !_skillsController.listAllSkills[index].isCheck;
                    _skillsController.listAllSkills.refresh();
                  }
                },
              ));
            }),
          )),
        ],
      ),
    );
  }
}


