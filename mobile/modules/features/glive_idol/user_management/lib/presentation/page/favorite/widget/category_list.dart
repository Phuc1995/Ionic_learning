import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/domain/usecase/skills/get_all_skills.dart';
import 'package:user_management/presentation/controller/skills/skills_controller.dart';
import 'package:user_management/presentation/widgets/checkbox_button_widget.dart';


class CategoryList extends StatefulWidget {
  const CategoryList({
    Key? key,
  }) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();

}
class _CategoryListState extends State<CategoryList> {
  SkillsController _skillsController = Get.put(SkillsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetAllSkill().call(NoParams()).then((value) {
      value.fold((l) => null, (data) {
        _skillsController.listAllSkills.value = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String _storageUrl = Modular.get<SharedPreferenceHelper>().storageServer + '/' + Modular.get<SharedPreferenceHelper>().bucketName + '/';
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Obx(()=> Wrap(
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
    );
  }
}
