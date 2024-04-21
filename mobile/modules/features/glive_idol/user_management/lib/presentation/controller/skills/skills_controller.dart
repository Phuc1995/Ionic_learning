import 'package:get/get.dart';
import 'package:user_management/domain/entity/response/category_response.dart';

class SkillsController extends GetxController {
  SkillsController();

  var listAllSkills = <CategoryResponse>[].obs;
  var listSkillsSelected = [].obs;

  @override
  void onInit() {
    super.onInit();
  }
}