import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // SharedPreferenceHelper instance
  late SharedPreferenceHelper _sharedPrefsHelper;

  var darkMode = false.obs;

  // constructor:---------------------------------------------------------------
  ThemeController();

  @override
  void onInit() async {
    super.onInit();
    _sharedPrefsHelper = await SharedPreferenceHelper.getInstance();
    darkMode.value = _sharedPrefsHelper.isDarkMode;
  }

  Future changeBrightnessToDark(bool value) async {
    darkMode.value = value;
    await _sharedPrefsHelper.setIsDarkMode(value);
  }

  bool isPlatformDark(BuildContext context) =>
      MediaQuery.platformBrightnessOf(context) == Brightness.dark;
}