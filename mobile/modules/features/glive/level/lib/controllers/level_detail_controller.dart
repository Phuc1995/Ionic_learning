import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:level/dto/level_policy_dto.dart';
import '../services/level_policy_service.dart';

class LevelDetailController extends GetxController{
  final _levelPolicyService = Modular.get<LevelPolicyService>();
  final String LEVEL = "LEVEL ";
  var listItemDetail = <LevelPolicyDto>[].obs;
  var currentExp = 0.obs;
  var maxExp = 0.obs;
  var minExp = 0.obs;
  var medalUrl = ''.obs;
  var level = ''.obs;
  var rankLevel = ''.obs;
  var storageUrl = ''.obs;

  Future<void>  refreshIdolExperience() async {
    final data = await _levelPolicyService.getIdolExperience();
    data.fold((l) => null, (data) {
      currentExp.value = data.currentExp;
      maxExp.value = data.maxExp == null ? data.currentExp : data.maxExp!;
      minExp.value = data.minExp;
      level.value = LEVEL + data.level;
      rankLevel.value = data.level.substring(data.level.length -1);
      medalUrl.value = storageUrl + data.medalUrl;
    });
  }

  double getValue() {
    return double.parse(this.currentExp.value.toString()) > double.parse(this.maxExp.value.toString()) ? double.parse(this.maxExp.value.toString()) : double.parse(this.currentExp.value.toString());
  }

  String labelSlider(){
    double expAtLevel = double.parse(this.currentExp.value.toString()) - double.parse(this.minExp.value.toString());
    double rankAtLevel = double.parse(this.maxExp.value.toString()) - (double.parse(this.minExp.value.toString()));
    double result = (expAtLevel/rankAtLevel) * 100;
    return result.toStringAsFixed(2)+ "%";
  }
}