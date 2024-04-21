import 'dart:ui';

import 'package:common_module/common_module.dart';
import 'package:get/get.dart';
import 'package:user_management/domain/entity/language/Language.dart';

class LanguageController extends GetxController {

  LanguageController();

  // supported languages
  List<Language> supportedLanguages = [
    Language(code: 'US', locale: 'en', language: 'English'),
    Language(code: 'VN', locale: 'vi', language: 'Tiếng Việt'),
  ];

  var locale = ''.obs;

  // SharedPreferenceHelper instance
  late SharedPreferenceHelper _sharedPrefsHelper;

  @override
  void onInit() async {
    super.onInit();
    locale.value = 'vi';
    _sharedPrefsHelper = await SharedPreferenceHelper.getInstance();
    // getting current language from shared preference
    if(_sharedPrefsHelper.currentLanguage != null) {
      locale.value = _sharedPrefsHelper.currentLanguage!;
    }
  }

  // actions:-------------------------------------------------------------------
  void changeLanguage(String value) {
    locale.value = value;
    _sharedPrefsHelper.setLanguage(value).then((_) {
      // write additional logic here
    });
  }

  Locale getLocale() {
    var lang = supportedLanguages[supportedLanguages.indexWhere((language) => language.locale == locale.value)];
    return Locale(lang.locale!, lang.code);
  }

  String? getLanguage() {
    return supportedLanguages[supportedLanguages
        .indexWhere((language) => language.locale == locale.value)]
        .language;
  }
}