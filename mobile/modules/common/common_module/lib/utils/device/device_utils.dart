//
import 'dart:io';

import 'package:common_module/common_module.dart';
import 'package:common_module/dto/device_info_dto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Helper class for device related operations.
///
class DeviceUtils {

  ///
  /// hides the keyboard if its already open
  ///
  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static getWidthDevice(BuildContext context){
    return MediaQuery.of(context).size.width;
  }

  static getHeightDevice(BuildContext context){
    return MediaQuery.of(context).size.height;
  }

  ///
  /// accepts a double [scale] and returns scaled sized based on the screen
  /// orientation
  ///
  static double getScaledSize(BuildContext context, double scale) =>
      scale *
          (MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.height);

  ///
  /// accepts a double [scale] and returns scaled sized based on the screen
  /// width
  ///
  static double getScaledWidth(BuildContext context, double scale) =>
      scale * MediaQuery.of(context).size.width;

  ///
  /// accepts a double [scale] and returns scaled sized based on the screen
  /// height
  ///
  static double getScaledHeight(BuildContext context, double scale) =>
      scale * MediaQuery.of(context).size.height;

  static double getPositionWidgetY(GlobalKey key){
    RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position
    return position.dy;
  }

  static Future<DeviceInfoDto> getDeviceId() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    DeviceInfoDto deviceInfo = DeviceInfoDto();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      print('Running on ${iosInfo.utsname.machine}');
      deviceInfo.deviceId = iosInfo.identifierForVendor!;
      deviceInfo.deviceModel = iosInfo.model!;
      return deviceInfo;
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      print('Running on ${androidInfo.model}');
      deviceInfo.deviceId = androidInfo.androidId!;
      deviceInfo.deviceModel = androidInfo.model!;
      return deviceInfo;
    }
  }

  static Widget buildWidget(BuildContext context, Widget child) {
    if (FlavorConfig.instance!.name == null ||
        FlavorConfig.instance!.name!.isEmpty) {
      return child;
    }
    return Stack(
      children: <Widget>[
        child,
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onLongPress: () {
            // if(dotenv.env['APPLE_CLIENT_ID']!.contains('idol')){
            //   Modular.to.pushNamed(IdolRoutes.user_management.environment);
            // } else {
            //   Modular.to.pushNamed(ViewerRoutes.environment);
            // }
          },
        ),
      ],
    );
  }
  ///
  /// accepts a double [size] and returns scaled sized based on the screen
  /// height
  ///

}
