import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/app_theme.dart';
import 'package:user_management/controllers/controllers.dart';
import 'package:user_management/controllers/language_controller.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:common_module/utils/i18n/glive/translation.dart';
import 'package:user_management/presentation/page/home_page/home_page.dart';
import 'package:user_management/presentation/page/login_page/login_page.dart';

class RootPage extends StatelessWidget {

  // This widget is the root of your application.
  // Create your store as a final variable in a base Widget. This works better
  // with Hot Reload than creating it directly in the `build` function.
  //controllers:-----------------------------------------------------------------
  final ThemeController themeController = Get.put(ThemeController());
  final LanguageController languageController = Get.put(LanguageController());
  final UserStoreController userController = Get.put(UserStoreController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.APP_NAME,
      theme: themeController.darkMode.value ? themeDataDark : themeData,
      // routes: Routes.routes,
      translations: Translation(),
      fallbackLocale: Locale('vi', 'VN'),
      locale: languageController.getLocale(),
      supportedLocales: languageController.supportedLanguages
          .map((language) => Locale(language.locale!, language.code))
          .toList(),
      localizationsDelegates: [
        // A class which loads the translations from JSON files
        // AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
        // Built-in localization of basic text for Cupertino widgets
        GlobalCupertinoLocalizations.delegate,
      ],
      home: FutureBuilder(
        future: userController.refreshToken(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Obx(() => userController.isLoggedIn.value ? HomePage(currentPage: 0,) : LoginPage());
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
