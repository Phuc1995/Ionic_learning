//  app_widget.dart
import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/app_theme.dart';
import 'package:user_management/presentation/controller/theme/theme_controller.dart';

class AppWidget extends StatelessWidget {
  // This widget is the root of your application.
  // Create your store as a final variable in a base Widget. This works better
  // with Hot Reload than creating it directly in the `build` function.
  //controllers:-----------------------------------------------------------------
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {

    return FlavorBanner(
      color: Colors.red,
      location: BannerLocation.topEnd,
      child: ScreenUtilInit(
        designSize: Size(414, 896),
        builder: () {
          Modular.routerDelegate.setNavigatorKey(GlobalState.navigatorKey);
          return MaterialApp.router(
            routeInformationParser: Modular.routeInformationParser,
            routerDelegate: Modular.routerDelegate,
            debugShowCheckedModeBanner: false,
            theme: themeController.darkMode.value ? themeDataDark : themeData,
          );
        },
      )
    );
  }
}
