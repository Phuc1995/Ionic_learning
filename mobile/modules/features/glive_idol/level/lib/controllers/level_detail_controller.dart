import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:level/services/services.dart';

class LevelDetailController extends GetxController {
  final _levelPolicyService = Modular.get<LevelPolicyService>();
  var listItemDetail = [].obs;
  var currentExp = 0.obs;
  var maxExp = 0.obs;
  var minExp = 0.obs;
  var medalUrl = ''.obs;
  var level = ''.obs;
  var rankLevel = ''.obs;
  var storageUrl = ''.obs;
  var isNoNetwork = false.obs;

  Future<void>  refreshIdolExperience(BuildContext context) async {
        final data = await _levelPolicyService.getIdolExperience();
        data.fold((failure) {
          this.isNoNetwork.value = true;
        }, (data) {
          currentExp.value = data.currentExp;
          maxExp.value = data.maxExp;
          minExp.value = data.minExp;
          level.value = data.level;
          rankLevel.value = data.level.substring(data.level.length -1);
          medalUrl.value = storageUrl + data.medalUrl;
          this.isNoNetwork.value = false;
        });
  }
}
